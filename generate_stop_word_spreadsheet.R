library(jsonlite)

stop_words <- fromJSON("./res/stop_words.json")
df <- data.frame(stop_word = stop_words)
write.csv(df, "./res/stop_words.csv", row.names = FALSE)
