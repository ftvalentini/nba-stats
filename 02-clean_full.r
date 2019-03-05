source("libraries.R")
source("functions.R")

# read data ---------------------------------------------------------------

rs = readRDS("data/working/rs.rds")
po = readRDS("data/working/po.rds")

# clean -------------------------------------------------------------------

# append and preprocess
full = list("Regular season"=rs, "Playoffs"=po) %>% bind_rows(.id="stage") %>% 
  mutate(
    pos_per_48 = pace,
    pts_per_48 = (pts / (mp/5)) * 48,
    pts_per_pos = pts_per_48 / pos_per_48,
    fg3perc = fg3 / fg3a ,
    fg2perc = fg2 / fg2a ,
    ftperc = ft / fta,
    fg3a_per_48 = (fg3a / (mp/5)) * 48,
    fg2a_per_48 = (fg2a / (mp/5)) * 48,
    fta_per_48 = (fta / (mp/5)) * 48
  )


# save --------------------------------------------------------------------

saveRDS(full, file="data/working/full.rds")
