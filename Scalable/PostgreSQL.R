library(RPostgreSQL)
library(DBI)
library(jsonlite)

# Connect to the database
con <- dbConnect(RPostgreSQL::PostgreSQL(), dbname="reddit", 
                 host="localhost", port=5432, 
                 user="postgres", password="Forkman39")

# Create table in SQL
dbExecute(con, "
CREATE TABLE reddit_table (
    ups INTEGER,
    downs INTEGER,
    comment_id VARCHAR(255),
    author VARCHAR(255),
    parent_id VARCHAR(255),
    subreddit VARCHAR(255),
    link_id VARCHAR(255),
    score INTEGER,
    is_submitter BOOLEAN,
    body TEXT,
    depth INTEGER,
    controversiality INTEGER,
    created_utc INTEGER
)
")


# Decode the JSON data:
decode_message <- function(message) {
  df <- fromJSON(message, flatten=TRUE, simplifyDataFrame=TRUE)
  return(df)
}
# Combine the processing and storage steps:
store_data <- function(df) {
  dbWriteTable(con, "reddit_table", df, append=TRUE, row.names=FALSE)
}

# Combine the processing and storage steps:
process_and_store <- function(messages) {
  for (message in messages) {
    # Decode the message
    df <- decode_message(message)
    
    # Store in the database
    store_data(df)
  }
}


messages <- consume_messages()
process_and_store(messages)


