source("libraries.R")
source("functions.R")


# parameters --------------------------------------------------------------

years = 1979:2018 # años de comienzo de la temporada

# scrape data -------------------------------------------------------------

library(rvest)
bases = map(years, get_rs) %>% setNames(years)
# append bases
base = bind_rows(bases)


# save data ---------------------------------------------------------------

saveRDS(base, file="data/working/rs.rds")


