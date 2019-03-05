source("libraries.R")
source("functions.R")


# data --------------------------------------------------------------------

base = readRDS("data/working/full.rds")


# resumen -----------------------------------------------------------------

res = base %>% select(season, team_id, stage,
                       pts_per_48, pts_per_pos, pos_per_48,
                       fg3a_per_48, fg3perc, fg2a_per_48, fg2perc, fta_per_48, ftperc) %>% 
  gather(stat, value, -season, -team_id, -stage) %>% 
  group_by(season, stage, stat) %>% 
  summarise(value=mean(value)) %>% ungroup() %>% 
  mutate(
    stat=factor(stat, levels=c("pts_per_48","pts_per_pos","pos_per_48",
                               "fg3a_per_48","fg2a_per_48","fta_per_48",
                               "fg3perc","fg2perc","ftperc")),
    stage=factor(stage, levels=c("Regular season","Playoffs"))
  )



# labels ------------------------------------------------------------------

stat1_labs=c(
  pts_per_48 = "Points per 48 minutes"
)
stat2_labs=c(
  pts_per_pos = "Points per possession",
  pos_per_48 = "Possessions per 48 minutes"
)
stat3_labs=c(
  fg3a_per_48 = "3-Point Attempts per 48 minutes",
  fg2a_per_48 = "2-Point Attempts per 48 minutes"
)
stat4_labs=c(
  fg3perc = "FG% on 3-Point Attempts",
  fg2perc = "FG% on 2-Point Attempts"
)
stat5_labs=c(
  fta_per_48 = "Free Throw Attempts per 48 minutes",
  ftperc = "% on Free Throw Attempts"
)

statlabs = list(stat1_labs,stat2_labs,stat3_labs,stat4_labs,stat5_labs)

# plots -------------------------------------------------------------------

plotfunc = function(statlab) {
  ggplot(data=res %>% dplyr::filter(stat %in% names(statlab)),
         aes(x=season, y=value, color=stage)) +
    facet_wrap(~stat, scales="free", ncol=1, labeller=labeller(stat=statlab)) + 
    geom_line(size=1) +
    geom_point() +
    theme_minimal() +
    scale_x_continuous(breaks=seq(1980,2019,5), minor_breaks=seq(1980,2019,1)) +
    theme(
      strip.text=element_text(face="bold", size=11),
      legend.title=element_blank(),
      legend.position="bottom",
      axis.title=element_blank()
    ) +
    labs(subtitle="League averages",
         caption="Source: basketball-reference.com") +
    NULL
}

plots = map(statlabs, plotfunc)


# save --------------------------------------------------------------------

ggsave("output/plots/thread/plot1.png", plots[[1]], width=12*1.5, height=12, units="cm")
ggsave("output/plots/thread/plot2.png", plots[[2]], width=12, height=12*1.5, units="cm")
ggsave("output/plots/thread/plot3.png", plots[[3]], width=12, height=12*1.5, units="cm")
ggsave("output/plots/thread/plot4.png", plots[[4]], width=12, height=12*1.5, units="cm")
ggsave("output/plots/thread/plot5.png", plots[[5]], width=12, height=12*1.5, units="cm")





