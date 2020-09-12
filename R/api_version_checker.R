 api_version_checker <- function(v){
 library(rvest)
  
  url <- "https://vk.com/dev/versions"
  data <- read_html (url)
  apiV <- html_nodes(data, css = ".dev_version_num.fl_l")
  apiV <- html_text(apiV[1])
  ifelse(is.null(apiV), "5.122",apiV)
  
  
}
