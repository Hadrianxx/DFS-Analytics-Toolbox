#' @title Make cumulant tables
#' @name cumulant_tables
#' @description  compute the cumulants of all the players
#' @importFrom magrittr %>%
#' @export cumulant_tables
#' @param pbs a player box score
#' @param pfunc a points function
#' @param order_max maximum cumulant order (default 4)
#' @return a list of
#' \itemize{
#' \item minutes_cumulants the cumulants of player minutes, with row names identifying the players
#' \item fpoints_cumulants the cumulants of player fantasy points, with row names identifying the players}

cumulant_tables <- function(pbs, pfunc, order_max = 4) {
  input_data <- pbs %>% dplyr::mutate_(fpoints = pfunc(pbs)) %>%
    dplyr::select(date, player_full_name, own_team, min, fpoints)

  minutes_frame <-
    reshape2::acast(input_data, date ~ player_full_name, value.var = "min")
  minutes_cumulants <- moments::all.cumulants(
    moments::all.moments(minutes_frame, order.max = order_max, na.rm = TRUE))
  colnames(minutes_cumulants) <- colnames(minutes_frame)
  rownames(minutes_cumulants) <- paste("kappa", 0:order_max, sep = "")
  minutes_cumulants <- t(minutes_cumulants)

  fpoints_frame <-
    reshape2::acast(input_data, date ~ player_full_name, value.var = "fpoints")
  fpoints_cumulants <- moments::all.cumulants(
    moments::all.moments(fpoints_frame, order.max = order_max, na.rm = TRUE))
  colnames(fpoints_cumulants) <- colnames(fpoints_frame)
  rownames(fpoints_cumulants) <- paste("kappa", 0:order_max, sep = "")
  fpoints_cumulants <- t(fpoints_cumulants)
  return(list(
    minutes_cumulants = minutes_cumulants,
    fpoints_cumulants = fpoints_cumulants))
}

#' @title Lineup moments calculation
#' @name lineup_moments
#' @description compute the mean and variance of a lineup
#' @importFrom dplyr %>%
#' @importFrom stats var
#' @export lineup_moments
#' @param standings a data frame from a DraftKings standings CSV file
#' @param pbs a player box score
#' @param before date (character, 'yyyy-mm-dd') - only use data before this date
#' @return returns stuff

lineup_moments <- function(standings, pbs, before) {

  # compute the means and variances
  moments <- dplyr::mutate(pbs, DKFP = draftkings_points(pbs)) %>%
    dplyr::filter(DATE < lubridate::ymd(before, tz = "EST5EDT")) %>%
    dplyr::group_by(`PLAYER FULL NAME`) %>%
    dplyr::summarize(
      samples = length(DKFP),
      mean_minutes = mean(MIN),
      var_minutes = var(MIN),
      mean_dkfp = mean(DKFP),
      var_dkfp = var(DKFP))

  # define positions and initialize result data frame
  positions <- c("PG", "SG", "SF", "PF", "C", "F", "G", "UTIL")
  result <- dplyr::select(standings, EntryName, Rank, Points, Lineup) %>%
    dplyr::mutate(
    Quantile = 1 - (Rank - 1) / (length(Rank) - 1),
    MeanMinutes = 0,
    VarianceMinutes = 0,
    MeanDKFP = 0,
    VarianceDKFP = 0)

  # loop over the positions
  for (i in 1:length(positions)) {
    position <- positions[i]
    if (stringr::str_length(position) == 1) {
      left_regex <- stringr::str_pad(position, 3, "both")
    } else {
      left_regex <- stringr::str_pad(position, 3, "right")
    }
    if (i == length(positions)) {
      right_regex <- "$"
    } else {
      nextpos <- positions[i + 1]
      right_regex <- stringr::str_pad(
        nextpos, stringr::str_length(nextpos) + 2, "both")
    }
    regex <- paste(left_regex, "(.+)", right_regex, sep = "")
    player <- stringr::str_extract(result$Lineup, regex)
    player <- stringr::str_replace(player, left_regex, "")
    if (i != length(positions)) {
      player <- stringr::str_replace(player, right_regex, "")
    }

    # now we have a vector of player names at this position
    # look up their mean and variance in "moments"
    rownum <- stringdist::amatch(player, moments$`PLAYER FULL NAME`, maxDist = 8)
    result$MeanMinutes <- result$MeanMinutes +
      moments$mean_minutes[rownum]
    result$VarianceMinutes <- result$VarianceMinutes +
      moments$var_minutes[rownum]
    result$MeanDKFP <- result$MeanDKFP +
      moments$mean_dkfp[rownum]
    result$VarianceDKFP <- result$VarianceDKFP +
      moments$var_dkfp[rownum]
  }

  # compute a few more stats
  result <- dplyr::mutate(
    result,
    StDevDKFP = sqrt(VarianceDKFP),
    ZScore = (Points - MeanDKFP) / sqrt(VarianceDKFP),
    Floor = MeanDKFP - sqrt(VarianceDKFP),
    Ceiling = MeanDKFP + sqrt(VarianceDKFP))
  return(result)
}
