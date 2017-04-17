# internal input collection functions
.summary_columns <- 2:21
.analysis_columns <- 4:24
.seed <- 54321
.nrep <- 32
.num_archetypes <- 3

.arch_data <- function(pbs) {
  current_team <- pbs %>%
    dplyr::group_by_(~ player_full_name) %>%
    dplyr::filter_(~ date == max(date)) %>%
    dplyr::select_(~ player_full_name, ~ position, ~ own_team) %>%
    dplyr::ungroup()
  game_count <- pbs %>%
    dplyr::group_by_(~ player_full_name) %>%
    dplyr::summarize_(games = ~ length(min))
  pbsx <- pbs %>%
    dplyr::select_(~ player_full_name, ~ min:fdfp) %>%
    dplyr::group_by_(~ player_full_name) %>%
    dplyr::summarize_at(.funs = dplyr::funs(sum), .cols = .summary_columns) %>%
    dplyr::ungroup() %>%
    dplyr::full_join(game_count, by = "player_full_name") %>%
    dplyr::mutate_(min_per_game = ~ min / games) %>%
    dplyr::arrange_(~ player_full_name)
  pbsx <- current_team %>%
    dplyr::full_join(pbsx, by = "player_full_name")
  return(pbsx)
}

#' @title Archetypal Analysis
#' @name archetypal_analysis
#' @description perform an "archetypal athletes" analysis
#' @import magrittr
#' @export archetypal_analysis
#' @param pbs player box score
#' @return a list of
#' \itemize{
#' \item archetypes the parameters that define each archetype
#' \item players the players tagged with their loadings on each archetype
#' \item best the model object created in the analysis
#' \item archdata the numerical inputs for the model}

archetypal_analysis <- function(pbs) {

  # make input dataset
  archinput <- .arch_data(pbs)

    # run the archetypal analysis
  archdata <- as.matrix(archinput[, .analysis_columns])
  set.seed(.seed)
  as <- archetypes::stepArchetypes(
    data = archdata,
    method = archetypes::robustArchetypes,
    k = .num_archetypes,
    verbose = FALSE,
    nrep = .nrep)

  # pick best model
  best <- archetypes::bestModel(as[[1]])

  # get the archetype vectors
  archetypes <- tibble::as_tibble(t(archetypes::parameters(best)))

  # compute the ordering:
  # descending by first row, which is total minutes played
  ordering <- order(-archetypes[1, ])

  # get the alphas
  player_table <- tibble::as_tibble(best$alphas)

  # reorder the columns
  archetypes <- archetypes[, ordering]
  player_table <- player_table[, ordering]

  # column names
  colnames(archetypes) <- colnames(player_table) <-
    paste("Arch", seq(1, .num_archetypes), sep = "")
  colnames(archetypes)[1] <- colnames(player_table)[1] <- "Back"
  colnames(archetypes)[2] <- colnames(player_table)[2] <- "Front"
  colnames(archetypes)[3] <- colnames(player_table)[3] <- "Bench"
  archetypes <- dplyr::bind_cols(
    list(Metric = colnames(archdata)) %>% tibble::as_tibble(),
    archetypes
  )

  # add total column to player table
  player_table  %<>% as.data.frame()
  for (i in 1:3) {
    player_table[, i] <- scales::rescale(player_table[, i])
  }
  player_table %<>% tibble::as_tibble() %>% dplyr::mutate_(Overall = ~ Back + Front)

  # tag player_table with player names and positions
  player_table <- dplyr::bind_cols(
    dplyr::select_(archinput, ~ player_full_name, ~ position, ~ own_team),
    player_table) %>%
    dplyr::arrange_(~ desc(Overall))
  colnames(player_table)[1:3] <- c("Player", "Position", "Team")

  return(list(
    archetypes = archetypes,
    player_table = player_table,
    best = best,
    archdata = archdata))
}

#' @title Archetype Search
#' @name archetype_search
#' @description search for the best archetypal analysis of real box score values
#' @export archetype_search
#' @import magrittr
#' @param pbs player box score
#' @return an "as" object from archetypes::stepArchetypes

archetype_search <- function(pbs) {

  # make input dataset
  archinput <- .arch_data(pbs)

  # run the archetypal analysis
  max_arch <- 7
  archdata <- as.matrix(archinput[, .analysis_columns])
  set.seed(.seed)
  as <- archetypes::stepArchetypes(
    data = archdata,
    method = archetypes::robustArchetypes,
    k = 1:max_arch,
    verbose = FALSE,
    nrep = .nrep)
  return(as)
}

#' @title Ternary Plot
#' @name ternary_plot
#' @description a visualization of a set of players using `ggtern`
#' @export ternary_plot
#' @import magrittr
#' @import ggtern
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 scale_fill_manual
#' @param player_table a data frame with player archetype values
#' @param plot_title the plot title
#' @param top_label the label for the top apex (backcourt)
#' @param left_label the label for the left apex (frontcourt)
#' @return a `ggplot` object

ternary_plot <- function(player_table, plot_title, top_label, left_label) {

  # colour-blind-friendly palette
  cbPalette <- RColorBrewer::brewer.pal(n = 12, name = "Paired")
  xdata <- dplyr::mutate(
    player_table,
    `Player/Position` = paste(Player, Position, sep = "/"))
  plot_object <- ggtern(
    data = xdata, mapping =
      aes(x = Front, y = Back, z = Bench)) +
    geom_point(
      aes(fill = `Player/Position`), shape = 21, color = "black", size = 7) +
    theme_nomask() +
    scale_fill_manual(values = cbPalette) +
    ggtitle(plot_title) +
    Tlab(top_label) +
    Llab(left_label)
  return(plot_object)
}
