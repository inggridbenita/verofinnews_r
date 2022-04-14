library(stringr)
library(rjson)

remove.word <- function (teks, word) {
  # Fungsi ini digunakan untuk menghapus kata dari sebuah teks/kalimat
  splitted <- unlist(strsplit(teks, split = " "))
  splitted <- splitted[!splitted %in% word]
  return(paste(splitted, collapse = ' '))
}

change.word <- function (teks, word, replacement) {
  # Fungsi ini digunakan untuk mengganti kata dari sebuah teks/kalimat
  splitted <- unlist(strsplit(teks, split = " "))
  splitted[splitted == word] <- replacement
  return(paste(splitted, collapse = ' '))
}

df <- read.csv("./res/datasets/news.csv")
df$content <- str_remove(df$content, "Jakarta, CNN Indonesia -- ")

for (a in 0:9) {
  df$content <- str_replace_all(df$content, paste(a), " ")
  df$title <- str_replace_all(df$title, paste(a), " ")
}

punctuations <- c(
  "\\.",
  ",",
  ";",
  "\\(",
  "\\)",
  "!",
  "\\|",
  "\\?",
  ":",
  "'",
  "\"",
  "#",
  "-",
  "/",
  "\\[",
  "\\]",
  "\\*"
)
for (punctuation in punctuations) {
  df$content <- str_replace_all(df$content, punctuation, " ")
  df$title <- str_replace_all(df$title, punctuation, " ")
}

df$content <- str_squish(df$content)
df$title <- str_squish(df$title)

df$content <- tolower(df$content)
df$title <- tolower(df$title)

# Menghapus stop words
stop.words <- fromJSON(file = "./res/stop_words.json")
for (i in seq_len(nrow(df))) {
  content <- df[i, "content"]
  title <- df[i, "title"]
  for (word in stop.words) {
    content <- remove.word(content, word)
    title <- remove.word(title, word)
  }
  df[i, "content"] <- content
  df[i, "title"] <- title
}

# Menangani sinonim
word_sinonim <- fromJSON(file = "./res/synonym.json")
word_sinonim_names <- names(word_sinonim)
for (i in seq_len(nrow(df))) {
  title <- df[i, "title"]
  content <- df[i, "content"]
  for (word in word_sinonim_names) {
    title <- change.word(title, word, word_sinonim[word])
    content <- change.word(content, word, word_sinonim[word])
  }
  df[i, "title"] <- title
  df[i, "content"] <- content
}

## buat bikinfile csv
write.csv(df, './res/datasets/nyamnya.csv', row.names = FALSE)