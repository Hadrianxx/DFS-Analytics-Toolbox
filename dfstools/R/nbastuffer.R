# internal double digit function
.dd <- function(x) {
  as.integer(x >= 10)
}

#  Points calculators
#' @title Real-world points
#' @name real_points
#' @description Computes points from a box score
#' @export real_points
#' @param boxscore a player or game box score data frame
#' @return a vector of points
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' points <- real_points(playerbox)
#' }

real_points <- function(boxscore) {
  return(boxscore$pts)
}

#' @title DraftKings fantasy points
#' @name draftkings_points
#' @description Computes DraftKings fantasy points from a box score
#' @export draftkings_points
#' @param boxscore a player or game box score data frame
#' @return a vector of DraftKings fantasy points
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' dk_points <- draftkings_points(playerbox)
#' }

draftkings_points <- function(boxscore) {
  1.0 * boxscore$pts +
  0.5 * boxscore$x3p +
  1.25 * boxscore$tot +
  1.5 * boxscore$a +
  2.0 * boxscore$st +
  2.0 * boxscore$bl +
  -0.5 * boxscore$to +
  1.5 * boxscore$ddbl +
  3.0 * boxscore$tdbl
}

#' @title FanDuel fantasy points
#' @name fanduel_points
#' @description Computes FanDuel fantasy points from a box score
#' @export fanduel_points
#' @param boxscore a player or game box score data frame
#' @return a vector of FanDuel fantasy points
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' fd_points <- fanduel_points(playerbox)
#' }

fanduel_points <- function(boxscore) {
  1.0 * boxscore$pts +
  1.2 * boxscore$tot +
  1.5 * boxscore$a +
  2.0 * boxscore$st +
  2.0 * boxscore$bl +
  -1.0 * boxscore$to
}

#' @title Yahoo fantasy points
#' @name yahoo_points
#' @description Computes Yahoo fantasy points from a box score
#' @export yahoo_points
#' @param boxscore a player box score data frame
#' @return a vector of Yahoo fantasy points
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' yh_points <- yahoo_points(playerbox)
#' }

yahoo_points <- function(boxscore) {
  1.0 * boxscore$pts +
  0.5 * boxscore$x3p +
  1.2 * boxscore$tot +
  1.5 * boxscore$a +
  2.0 * boxscore$st +
  2.0 * boxscore$bl +
  -1.0 * boxscore$to
}

# internal date reformatter
.fixdate <- function(date_string) {
  lubridate::mdy(date_string)
}

#' @title Make player box score data frame
#' @name playerboxscore
#' @description Creates a player box score data frame from an NBAStuffer spreadsheet
#' @export playerboxscore
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @param spreadsheet a file with an NBAStuffer player box score dataset
#' @param sheet_number the sheet number within the spreadsheet (default 1)
#' @return a data frame of the input spreadsheet, augmented with columns for double-doubles and triple doubles
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' }

playerboxscore <- function(spreadsheet, sheet_number = 1) {
  df <- readxl::read_excel(spreadsheet, sheet = sheet_number) %>%
    dplyr::filter_(~ !is.na(DATE))
  colnames(df) <- .sensible_column_names(df)

  # comparable date stamp
  df$date <- .fixdate(df$date)

  # compute double-double and triple-double
  count <- .dd(df$tot) + .dd(df$a) + .dd(df$st) + .dd(df$bl) + .dd(df$pts)
  df$ddbl <- as.integer(count >= 2)
  df$tdbl <- as.integer(count >= 3)
  df$dkfp <- draftkings_points(df)
  df$fdfp <- fanduel_points(df)

  # result
  return(df)
}

#' @title Make game box score data frame from player box score
#' @name gameboxscore
#' @description Creates a game box score data frame from a player box score data frame
#' @export gameboxscore
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @param pbs a player box score data frame
#' @return a data frame of game box scores
#' @examples
#' \dontrun{
#' playerbox <- playerboxscore(
#'   "~/Dropbox/16-17-player-data/season-player-feed-02-03-2017.xlsx")
#' gamebox <- gameboxscore(playerbox)
#' }

gameboxscore <- function(pbs) {
  columns <- colnames(pbs)[8:25]
  df <- pbs %>% dplyr::group_by_(
    ~ data_set,
    ~ date,
    ~ own_team,
    ~ opp_team,
    ~ venue_r_h) %>%
    dplyr::summarize_at(.funs = dplyr::funs(sum), .cols = columns) %>%
    dplyr::ungroup()
  df$min <- round(df$min, 0)
  return(df)
}

# internal function to make sensible column names
.sensible_column_names <- function(df) {
  names <- colnames(df)
  names %<>%
    gsub(pattern = "\\W+", replacement = "_") %>%
    gsub(pattern = "\\s+", replacement = "_") %>%
    gsub(pattern = "^3", replacement = "x3") %>%
    gsub(pattern = "_$", replacement = "") %>%
    tolower()
  return(names)
}
