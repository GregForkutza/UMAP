all_embeddings <- list(
  cleaned_news_top_year_50_comments_5,
  cleaned_news_top_year_50_comments_10,
  cleaned_news_top_year_50_comments_15,  # Note that you loaded this twice, ensure it's correct
  cleaned_news_top_year_50_comments_20,
  cleaned_news_top_year_50_comments_25,
  cleaned_news_top_year_50_comments_30,
  cleaned_news_top_year_50_comments_35,
  cleaned_news_top_year_50_comments_40,
  cleaned_news_top_year_50_comments_45,
  cleaned_news_top_year_50_comments_50
)

# Flatten the embeddings list
flattened_embeddings <- unlist(all_embeddings, recursive = FALSE)

extract_top_comment_dates <- function(df_list) {
  top_comment_dates <- lapply(seq_along(df_list), function(i) {
    # Access the date of the first comment in each thread
    top_date <- df_list[[i]]$nodes$date[1]
    return(as.Date(as.POSIXct(top_date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")))  # Convert to Date object
  })
  return(unlist(top_comment_dates))  # Convert list to vector
}

# Usage
top_comment_dates <- extract_top_comment_dates(news_top_year_50_comments)
readable_dates <- as.Date(top_comment_dates, origin = "1970-01-01")


combined_embeddings_df <- data.frame(
  date = rep(readable_dates, each = 5),  # Repeat each date 5 times
  embeddings = I(flattened_embeddings)  # 'I' to keep the list structure in the data frame
)




# Assuming flattened_embeddings is a list of embeddings and readable_dates is a vector of dates
for(i in seq_along(flattened_embeddings)) {
  flattened_embeddings[[i]] <- list(embedding = flattened_embeddings[[i]], date = readable_dates[i])
}

# Get the order of the dates
date_order <- order(sapply(flattened_embeddings, function(x) x$date))

# Reorder the flattened_embeddings list
sorted_flattened_embeddings <- flattened_embeddings[date_order]


## Sort based on Date

# Initialize the starting index and the size for the first group
start_index <- 1
group_size <- 3

# Loop to break up the list and save as RDS files
repeat {
  # Select a subset of the list
  subset_embeddings <- sorted_flattened_embeddings[start_index:(start_index + group_size - 1)]
  print(c(start_index, group_size))
  # Save the subset as an RDS file
  saveRDS(subset_embeddings, paste0("data/embeddings/sorted_news_top_year_50_comments_", start_index, ".rds"))
  
  # Update the starting index for the next group
  start_index <- start_index + group_size
  
  # Break the loop if we have processed all elements
  if (start_index > length(flattened_embeddings)) {
    break
  }
  
  # Update the group size for the next iterations
  if (start_index == 4) { # After the first group of 3
    group_size <- 7
  } else {
    group_size <- 5
  }
}

# Assuming news_top_year_50_comments is your original list of comments
# And date_order is your vector with the chronological order

sorted_news_top_year_50_comments_sortbyembedding <- news_top_year_50_comments[date_order]
# You can then proceed with any further processing or saving this sorted list

saveRDS(sorted_news_top_year_50_comments_sortbyembedding, file = "sorted_news_top_year_50_comments_correct.rds")

# Reorder Comments data

# Assuming news_top_year_50_comments is your original list
# Step 1: Extract dates and pair them with their corresponding list element
paired_list <- lapply(news_top_year_50_comments, function(element) list(date = element$nodes$date[1], data = element))

# Step 2: Sort the paired list by date
sorted_list <- paired_list[order(sapply(paired_list, function(x) x$date))]

# Step 3: Extract the sorted elements back into the list structure
sorted_news_top_year_50_comments <- lapply(sorted_list, function(x) x$data)
saveRDS(sorted_news_top_year_50_comments, file = " sorted_news_top_year_50_comments.rds")
# Now sorted_news_top_year_50_comments is your original list sorted by date


# debugging
comment_dates <- c()
for (i in 1:50) {
  comment_dates[i]<- dfs[[i]]$nodes$date[1]
}

for (i in 21:25) {
  
  print(dim(clean_comments(dfs[[i]]$nodes)))
}

for (i in 1:5) {
  print(dim(sorted_news_top_year_50_comments_21[[i]]$embedding$texts$texts))

}

for (i in 1:50) {
  
  print(dim(flattened_embeddings[[i]]$texts$texts))
}

for (i in 1:50) {
  
  print(dim(news_top_year_50_comments[[i]]$nodes))
} 
  
