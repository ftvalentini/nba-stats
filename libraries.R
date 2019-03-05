
# packages "desiempre" y "proj" ---------------------------------------
# desiempre do not have to be explicitely called
# proj have to be explicitely called
paq_desiempre <- c(
  "magrittr",
  "purrr",
  "conflicted",
  "ggplot2",
  "dplyr",
  "broom",
  "knitr",
  "readr",
  "stringr",
  "tidyr",
  "bookdown",
  "kableExtra"
)
paq_proj <- c(
  "rvest",
  "XML",
  "RCurl"
)

# not touch ----------------------------------------------------------------
paq <- c(paq_desiempre,paq_proj)
for (i in seq_along(paq)) {
  if (!(paq[i] %in% installed.packages()[,1])) {
    install.packages(paq[i])
  }
  if (paq[i] %in% paq_desiempre) library(paq[i],character.only=T,warn.conflicts=F,quietly=T,verbose=F)
}
rm(paq,paq_desiempre,paq_proj)