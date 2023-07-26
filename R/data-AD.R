
library(dplyr)
library(sf)


## Load data -------------------------------------------------------------------
palette_lu <- data.frame(
  lu_id    = c("FMH", "FML", "FDL", "FM", "FC", "MF", "FP", "OWL", "SH", "G", "C", "S", "W", "O"),
  lu_fo    = c(rep("F", 7), rep("NF", 7)),
  lu_no    = 1:14,
  lu_color = c('#006400', '#32CD32', '#98FB98', '#8B4513', '#AFEEEE', '#1E90FF', '#D2691E', 
               "#BDB76B", '#BDB76B', '#BDB76B', '#F5DEB3', '#333333', '#333333', '#333333'),
  lu_en    = c("Highland Moist Forest", "Lowland Moist Forest", "Lowland Dry Forest", 
               "Mountain Forest", "Coastal Forest", "Mangrove Forest", "Forest plantation", 
               "Other wooded land", "Shrubland", "Grassland", "Cropland", "Settlement", 
               "Wetland", "Other land"),
  lu_te    = c("Ai-laran rai bokon a’as (FMH)", "Ai-laran rai bokon badak (FML)",
               "Ai-laran rai maran badak (FDL)", "TR Mountain forest (FM)",
               "Ai-laran costal  (FC)", "Ai-parapa (MF)", "Plantasaun ema mak kuda (FP)",
               "TR Other wooded land (OWL)", "Arbustos (SH)", "Du’ut (G)", "Toos (C)",
               "Area hela fatin (S)", "TR Wetland (W)", "TR Other land (O)") 
)

palette_redd <- data.frame(
  redd_FRL    = c("AF", "DF", "SF", "SNF"),
  redd_color  = c("#36B0C7", "#D60602", "#207A20", "#333333"),
  redd_FRL_en = c("Afforestation", "Deforestation", "Stable forest", "Stable non-forest"),
  redd_FRL_te = c("TR Afforestation", "TR Deforestation", "TR Stable forest", "TR Stable non-forest")
)


sf_country   <- st_read("data/TimorLeste.geoJSON", quiet = TRUE)
sf_AD_square <- st_read("data/sf_AD_square.geoJSON", quiet = T)
sf_AD        <- st_read("data-raw/AD-spatial-grid2.geoJSON", quiet = T) 


## Make spatial layers ---------------------------------------------------------
sf_AD2 <- sf_AD |>
  select(seqnum, id, redd_FRL, starts_with("lu_end")) |>
  left_join(palette_redd, by = "redd_FRL") |>
  #left_join(palette_lu, by = "lu_id") |>
  mutate(ID = as.character(id)) ## Necessary for setStyle() to work

sf_change <- sf_AD |>
  filter(redd_FRL %in% c("AF", "DF")) |>
  select(id, redd_FRL, lu_code_init, lu_code, lu_change_year) |>
  left_join(select(palette_redd, redd_FRL, redd_FRL_en, redd_FRL_te), by = "redd_FRL") |>
  left_join(select(palette_lu, lu_id, lu_en, lu_te), by = c("lu_code" = "lu_id"), ) |>
  left_join(select(palette_lu, lu_id, lu_en, lu_te), by = c("lu_code_init" = "lu_id"), suffix = c("", "_init")) |>
  mutate(
    redd_FRL_en_color = if_else(
      redd_FRL == "AF",
      paste0("<span class='text-success'>", redd_FRL_en, "</span>"),
      paste0("<span class='text-danger'>", redd_FRL_en, "</span>"),
    ),
    redd_FRL_te_color = if_else(
      redd_FRL == "AF",
      paste0("<span class='text-success'>", redd_FRL_te, "</span>"),
      paste0("<span class='text-danger'>", redd_FRL_te, "</span>"),
    ),
    icon_color = if_else(
      redd_FRL == "AF",
      HTML(bsicons::bs_icon("caret-down-fill", size = "2em", class = "text-success")),
      HTML(bsicons::bs_icon("caret-down-fill", size = "2em", class = "text-danger"))
    ),
    label_en = paste0(
      "<div style='text-align:center;'>",
      "<h6>", redd_FRL_en_color, " in ", lu_change_year, "</h6><br/>",
      lu_en_init, "<br/>",
      icon_color, "<br/>",
      lu_en, "</div>"
    ),
    label_te = paste0(
      "<div style='text-align:center;'>",
      "<h6>", redd_FRL_te_color, " iha ", lu_change_year, "</h6><br/>",
      lu_te_init, "<br/>",
      icon_color, "<br/>",
      lu_te, "</div>"
    )
  )




## MISC 
# tt <- sf_AD |>
#   as_tibble() |>
#   mutate(change_year = if_else(!is.na(DF_year), DF_year, AF_year)) |>
#   filter(!is.na(change_year)) |>
#   group_by(change_year, redd_FRL) |>
#   summarise(area = n() * 3.554735, .groups = "drop")
# 
# gg <- ggplot(tt, aes(x = change_year, y = area, color = redd_FRL)) +
#   geom_point() +
#   geom_line()
# 
# gg