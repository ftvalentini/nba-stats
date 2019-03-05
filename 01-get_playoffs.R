source("libraries.R")
source("functions.R")


# parameters --------------------------------------------------------------

years = 1979:2017 # años de comienzo de la temporada

# scrape data -------------------------------------------------------------

library(rvest)
bases = map(years, get_po) %>% setNames(years)
# append bases
base = bind_rows(bases, .id="season")
base$season = as.numeric(base$season)

# save data ---------------------------------------------------------------

saveRDS(base, file="data/working/po.rds")


