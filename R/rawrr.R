library(reticulate)
use_virtualenv("/Users/SenseiGregory/.virtualenvs/r-reticulate", required = TRUE)
# use_python("/Users/SenseiGregory/.virtualenvs/r-reticulate/bin/python")
py_config()
library(rawrr)
library(httr)
library(tidyverse)
library(jsonlite)
client_id <- "q1vvgIe6E8n7rgfcovg7KQ"
client_secret <- "MFkw2VP8S76lRJ7nLA_D2Msp7RLcpA"

rawrr::init_reddit("forkman3939", "Bzitgomd39!", client_id, client_secret )

urls <- readRDS(file = "news_top_year_50.rds")

extract_threads <- function(url_list, replace_limit = 10) {
  # Initialize a list to store the results
  thread_list <- list()
  permalinks <-  unlist(url_list[1])
  # Loop over the permalinks
  for (permalink in permalinks) {

    # Extract the thread
    thread <- rawrr::extract_thread(permalink, replace_limit = replace_limit)
    
    # Append to the list
    thread_list[[permalink]] <- thread
  }
  
  # Return the list of threads
  return(thread_list)
}

dfs1<- extract_threads(urls)

saveRDS(dfs1, file = "news_top_year_50_comments.rds")
