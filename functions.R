source("libraries.R")

# concatenate strings
"%+%" = function(a,b) paste(a,b,sep="")

# read regular season teams data from play index according to query for a single season
get_rs = function(year_inicio) {
  year = year_inicio + 1
  root = "https://www.basketball-reference.com/play-index/tsl_finder.cgi?"
  queries = c(
    "request=1&match=single&type=team_totals&year_min="%+%year%+%"&year_max="%+%year%+%"&lg_id=NBA&order_by=year_id",
    "request=1&match=single&type=team_per_game&year_min="%+%year%+%"&year_max="%+%year%+%"&lg_id=NBA&order_by=year_id",
    "request=1&match=single&type=advanced&year_min="%+%year%+%"&year_max="%+%year%+%"&lg_id=NBA&order_by=year_id"
  )
  urls = root %+% queries
  dat_list = list()
  u = urls[1]
    for (u in urls) {
    web = html_session(u)
    varnames = html_nodes(web, "#stats > thead > tr > th") %>% html_attr("data-stat") %>%
      "["(match("season",.):length(.))
    nc = length(varnames)
    dat_temp = html_nodes(web, "#stats > tbody > tr > td") %>% html_text() %>% 
      matrix(ncol=nc, byrow=T) %>% as_tibble() %>% set_colnames(varnames) %>% 
      mutate_at(4:ncol(.), function(x) as.numeric(x))
    dat_temp$team_id = str_extract(dat_temp$team_id, "[:alpha:]+")
    dat_temp$season = substr(dat_temp$season, 1, 4) %>% as.numeric()
    dat_list[[u]] = dat_temp
    }
  dat = reduce(dat_list, function(a,b) full_join(a, b, by=c("season","team_id"))) %>% 
    select(-ends_with(".y")) %>% 
    select(-ends_with(".x"))
  return(dat)
  # while (str_detect(page_buttons, "Next page")) {}
  # page_buttons = web %>% html_nodes("#pi > div.p402_premium > p") %>% html_text()
  # page_buttons = web %>% html_nodes("#pi > div.p402_premium > p") %>% html_text()
  # web = web %>% follow_link("Next page")
}

# read playoffs teams data for a single season
get_po = function(year_inicio) {
  year = year_inicio + 1
  url = "https://www.basketball-reference.com/playoffs/NBA_"%+%year%+%".html"
  web = read_html(url)
  varnames = html_nodes(web, "#team-stats-per_game > thead > tr > th") %>% html_attr("data-stat") %>%
    "["(match("team_name",.):length(.))
  nc = length(varnames)
  dat_temp = html_nodes(web, "#team-stats-per_game > tbody > tr > td") %>% html_text() %>% 
    matrix(ncol=nc, byrow=T) %>% as_tibble() %>% set_colnames(varnames) %>% 
    mutate_at(2:ncol(.), function(x) as.numeric(x)) %>% 
    dplyr::filter(team_name!="League Average") %>% 
    rename(team_id=team_name)
  # add pace
  html = RCurl::getURL(url, followlocation=TRUE)
  doc = XML::htmlParse(html)
  misc = XML::xpathSApply(doc, '//*[@id="all_misc"]')[[1]]
  text = XML::xmlChildren(misc)$comment %>% XML::xmlValue()
  teams = str_match_all(text, 'data-stat=\"team_name\" ><a href=\"/teams/(.*?)/(.*?).html\">(.*?)</a>')[[1]][,4]
  paces = str_match_all(text, 'data-stat=\"pace\" >(.*?)</td>')[[1]][,2] %>% 
    "["(-length(.)) %>% as.numeric()
  dat_pace = tibble(team_id=teams, pace=paces)
  dat = dat_temp %>% inner_join(dat_pace, by="team_id")
  return(dat)
}
