# 
# library(readr)
# 
# ef_plot <- read_csv("data-raw/EF_plot_level_NFItest_40plots.csv", show_col_types = FALSE)
# 
# ef_plot
# table(ef_plot$lf_landcover2)
# 
# 
# ef <- ef_plot |>
#   group_by(lf_landcover2) |>
#   summarise(
#     n_plot     = n(),
#     agb_all    = round(mean(plot_agb_ha), 3),
#     bgb_all    = round(mean(plot_bgb_ha), 3),
#     carbon_tot = round(mean(plot_carbon_ha), 3),
#     sd_carbon  = sd(plot_carbon_ha),
#     .groups = "drop"
#   ) |>
#   mutate(
#     ci      = sd_carbon / sqrt(n_plot) * round(qt(0.975, n_plot-1), 2),
#     ci_perc = round(ci / carbon_tot * 100, 0)
#   )
# 
# ef_sort <- ef %>%
#   filter(lf_landcover2 != "Non forest") %>%
#   select(lf_landcover2, n_plot, carbon_tot, ci_perc)
