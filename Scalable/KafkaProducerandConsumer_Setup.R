library(reticulate)
library(jsonlite)

# Import the confluent_kafka library from Python
confluent_kafka <- import('confluent_kafka')

# Define Kafka configuration
conf <- list(
  bootstrap.servers = 'localhost:9092' # Adjust to your Kafka broker's address
)

# Create a Kafka producer instance
producer <- confluent_kafka$Producer(conf)


# Serialize data to JSON:
json_data <- toJSON(df_clean, pretty = TRUE)

# Produce the Message to Kafka:
producer$produce(topic='reddit_data', value=json_data)
producer$flush()  # Ensures all outstanding producer requests are completed


# Define Kafka consumer configuration
conf <- list(
  bootstrap.servers = 'localhost:9092', # Kafka broker's address
  group.id = 'reddit_consumer_group',   # Consumer group id
  auto.offset.reset = 'earliest'       # Start from the beginning of the topic
)

# Create a Kafka consumer instance
consumer <- confluent_kafka$Consumer(conf)

# Subscribe to the topic:
consumer$subscribe(list('reddit_data'))

# Consume messages in batches
consume_messages <- function(batch_size = 1000, timeout = 1000) {
  messages <- list()
  
  for (i in seq_len(batch_size)) {
    # Try to consume a message
    msg <- consumer$poll(timeout / 1000) # timeout is in seconds
    
    if (!is.null(msg$error)) { 
      # Handle potential error
      print(paste("Error while consuming message:", msg$error))
    } else {
      # Append message value to the list
      messages[[i]] <- msg$value   # Change this line
    }
  }
  
  # Return the list of messages
  return(messages)
}



