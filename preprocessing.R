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

# Mengganti tanda baca dengan spasi
punctuations <- c(
  ";",
  "\\(",
  "\\)",
  "!",
  "\\|",
  "\\?",
  ":",
  "\"",
  "#",
  "-",
  "/",
  "\\[",
  "\\]",
  "\\*",
  '%'
)
for (punctuation in punctuations) {
  df$content <- str_replace_all(df$content, punctuation, " ")
  df$title <- str_replace_all(df$title, punctuation, " ")
}

# Menghapus tanda baca
punctuations <- "'"
for (punctuation in punctuations) {
  df$content <- str_replace_all(df$content, punctuation, "")
  df$title <- str_replace_all(df$title, punctuation, "")
}

# Menghapus kelebihan spasi
df$content <- str_squish(df$content)
df$title <- str_squish(df$title)

# Mengubah ke lowercase
df$content <- tolower(df$content)
df$title <- tolower(df$title)

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

# buat bikin file csv
write.csv(df, './res/datasets/news_preprocessed.csv', row.names = FALSE, fileEncoding = "UTF-8")
