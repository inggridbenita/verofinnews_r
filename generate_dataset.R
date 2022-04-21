library(rjson)

categories <- c("gaya_hidup", "hiburan")

ids_vector <- NULL
titles_vector <- NULL
dates_vector <- NULL
contents_vector <- NULL
links_vector <- NULL
posters_vector <- NULL
category_vector <- NULL

id <- 0
for (category in categories) {
  news <- fromJSON(file = paste0("./res/data_berita/",category,".json"))

  for (i in seq_len(length(news))) {
    id <- id + 1
    sub_list <- news[i]
    sub_list <- sub_list[[1]]

    ids_vector <- c(ids_vector, id)
    titles_vector <- c(titles_vector, sub_list$title)
    dates_vector <- c(dates_vector, sub_list$date)
    contents_vector <- c(contents_vector, sub_list$content)
    links_vector <- c(links_vector, sub_list$link)
    posters_vector <- c(posters_vector, sub_list$poster)
    category_vector <- c(category_vector, category)
  }
}

df <- data.frame(
  id = ids_vector,
  title = titles_vector,
  date = dates_vector,
  content = contents_vector,
  link = links_vector,
  poster = posters_vector,
  category = category_vector
)

write.csv(df, "./res/news.csv", row.names = FALSE, fileEncoding = "UTF-8")