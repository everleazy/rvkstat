vkGetUserWall <- function(user_id = NULL,
                          domain = NULL,
                          filter = NULL,
						  api_version = NULL,
                          access_token = NULL){
  
  if(is.null(access_token)){
    stop("Не заполнен access_token, этот аргумент является обязательным.")
  }
  
  #Проверка версии API
  api_version <- api_version_checker(api_version)
  
  #Рещультирующая таблица
  result <- data.frame(stringsAsFactors = F)  
  
  #Постраничная выгрузка
  offset <- 0
  count <- 100
  last_iteration <- FALSE
  
  while(last_iteration == FALSE){
    #Oi?ie?oai cai?in
    query <- paste0("https://api.vk.com/method/wall.get?extended=1",ifelse(is.null(user_id),"",paste0("&owner_id=",user_id)),ifelse(is.null(domain),"",paste0("&domain=",domain)),"&offset=",offset,"&count=100",ifelse(is.null(filter),"",paste0("&filter=",filter)),"&access_token=",access_token,"&v=",api_version)
    answer <- GET(query)
    stop_for_status(answer)
    dataRaw <- content(answer, "parsed", "application/json")
    
    #I?iaa?ea ioaaoa ia ioeaee
    if(!is.null(dataRaw$error)){
      stop(paste0("Error ", dataRaw$error$error_code," - ", dataRaw$error$error_msg))
    }
    
    if (api_version < 5){
    for(i in 2:length(dataRaw$response$wall)){
      
      result  <- rbind(result,
                       data.frame(id                            = ifelse(is.null(dataRaw$response$wall[[i]]$id), NA,dataRaw$response$wall[[i]]$id),
                                  from_id                       = ifelse(is.null(dataRaw$response$wall[[i]]$from_id), NA,dataRaw$response$wall[[i]]$from_id),
                                  to_id                         = ifelse(is.null(dataRaw$response$wall[[i]]$to_id), NA,dataRaw$response$wall[[i]]$to_id),
                                  date                          = ifelse(is.null(dataRaw$response$wall[[i]]$date), NA,dataRaw$response$wall[[i]]$date),
                                  post_type                     = ifelse(is.null(dataRaw$response$wall[[i]]$post_type), NA,dataRaw$response$wall[[i]]$post_type),
                                  text                          = ifelse(is.null(dataRaw$response$wall[[i]]$text), NA,dataRaw$response$wall[[i]]$text),
                                  can_delete                    = ifelse(is.null(dataRaw$response$wall[[i]]$can_delete), NA,dataRaw$response$wall[[i]]$can_delete),
                                  comments_count                = ifelse(is.null(dataRaw$response$wall[[i]]$comments$count), NA,dataRaw$response$wall[[i]]$comments$count),
                                  likes_count                   = ifelse(is.null(dataRaw$response$wall[[i]]$likes$count), NA,dataRaw$response$wall[[i]]$likes$count),
                                  reposts_count                 = ifelse(is.null(dataRaw$response$wall[[i]]$reposts$count), NA,dataRaw$response$wall[[i]]$reposts$count),
                                  attachment_type               = ifelse(is.null(dataRaw$response$wall[[i]]$attachment$type), NA,dataRaw$response$wall[[i]]$attachment$type),
                                  stringsAsFactors = F))}
    
    #Ia?aaiaei aaoo a io?iue oi?iao
    if(length(dataRaw$response$wall) < 100){
      last_iteration <- TRUE}
    
    #Niauaai offet
    offset <- offset + count
    Sys.sleep(0.5)
 
    
  } else {
  
    for(i in 1:length(dataRaw$response$items)){
      
      result  <- rbind(result,
                       data.frame(id                            = ifelse(is.null(dataRaw$response$items[[i]]$id), NA,dataRaw$response$items[[i]]$id),
                                  from_id                       = ifelse(is.null(dataRaw$response$items[[i]]$from_id), NA,dataRaw$response$items[[i]]$from_id),
                                  to_id                         = ifelse(is.null(dataRaw$response$items[[i]]$to_id), NA,dataRaw$response$items[[i]]$to_id),
                                  date                          = ifelse(is.null(dataRaw$response$items[[i]]$date), NA,dataRaw$response$items[[i]]$date),
                                  post_type                     = ifelse(is.null(dataRaw$response$items[[i]]$post_type), NA,dataRaw$response$items[[i]]$post_type),
                                  text                          = ifelse(is.null(dataRaw$response$items[[i]]$text), NA,dataRaw$response$items[[i]]$text),
                                  can_delete                    = ifelse(is.null(dataRaw$response$items[[i]]$can_delete), NA,dataRaw$response$items[[i]]$can_delete),
								  views                         = ifelse(is.null(dataRaw$response$items[[i]]$views$count), NA,dataRaw$response$items[[i]]$views$count),
                                  comments_count                = ifelse(is.null(dataRaw$response$items[[i]]$comments$count), NA,dataRaw$response$items[[i]]$comments$count),
                                  likes_count                   = ifelse(is.null(dataRaw$response$items[[i]]$likes$count), NA,dataRaw$response$items[[i]]$likes$count),
                                  reposts_count                 = ifelse(is.null(dataRaw$response$items[[i]]$reposts$count), NA,dataRaw$response$items[[i]]$reposts$count),
                                  attachment_type               = ifelse(is.null(dataRaw$response$items[[i]]$attachment$type), NA,dataRaw$response$items[[i]]$attachment$type),
                                  stringsAsFactors = F))}
    
    #Ia?aaiaei aaoo a io?iue oi?iao
    if(length(dataRaw$response$items) < 100){
      last_iteration <- TRUE}
    
    #Niauaai offet
    offset <- offset + count
    Sys.sleep(0.5)
  }
  }
  
  #Преобразуем дату в  формат Windows
  result$date <- as.POSIXct(as.integer(result$date), origin="1970-01-01")
  #Возвращаем результирующий дата фрейм
  return(result)
}
