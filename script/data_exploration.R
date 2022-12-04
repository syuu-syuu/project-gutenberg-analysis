library(devtools)
library(gutenbergr)
library(tidyverse)
library(tidytext)
library(ggpubr)
library(wordcloud)


## summary stat for language
languages = gutenberg_languages %>%
  group_by(language) %>%
  summarise(n = sum(total_languages)) %>%
  arrange(desc(n)) %>%
  filter(n >10)
languages$language <- factor(languages$language, levels=unique(languages$language))

p_language = ggplot(data = languages) +
  geom_bar(aes(x = language, y = log10(n)), stat = "identity", fill="lightblue") +
  scale_y_continuous(breaks = 0:5, labels = c(expression(10^0),expression(10^1), expression(10^2), expression(10^3), expression(10^4), expression(10^5))) +
  ylab(label = "No. books") +
  xlab(label = "Language") +
  theme_light()
ggsave(p_language, filename = "./results/language.pdf", height = 4, width = 8)

## summary stat for authors
authors = gutenberg_authors %>%
  filter(birthdate > 1550, deathdate > 1550, deathdate > birthdate)

birth = ggplot(data = authors, aes(x = birthdate))+
  geom_histogram(binwidth = 10, fill="lightblue")+
  geom_density(aes(y= 10 * ..count..), color = "red") +
  ylab(label = "No. authors") +
  xlab(label = "Birth year") +
  labs(title = "Distribution of birth years")+
  theme_light()

death = ggplot(data = authors, aes(x = deathdate))+
  geom_histogram(binwidth = 10, fill="lightblue")+
  geom_density(aes(y= 10 * ..count..), color = "red") +
  ylab(label = "No. authors") +
  xlab(label = "Death year") +
  labs(title = "Distribution of death years")+
  theme_light()

age = ggplot(data = authors, aes(x = deathdate-birthdate))+
  geom_histogram(binwidth = 3, fill="lightblue")+
  geom_density(aes(y= 3 * ..count..), color = "red") +
  ylab(label = "No. authors") +
  xlab(label = "Age") +
  labs(title = "Distribution of ages")+
  theme_light()

p_authors = ggarrange(birth, death, age, ncol = 1, nrow = 3)
ggsave(p_authors, filename = "./results/authors.pdf", height = 6, width = 6)

## summary stat for subjects
subjects = gutenberg_subjects %>%
  group_by(subject) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  filter(n < 20)
subjects$subject = as.character(subjects$subject)
subjects$subject <- factor(subjects$subject, levels=unique(subjects$subject))

p_subjects = ggplot(data = subjects) +
  geom_histogram(aes(x = n), binwidth = 1, fill = "lightblue")+
  ylab(label = "No. subjects") +
  xlab(label = "No. books per subject") +
  theme_light()

ggsave(p_subjects, filename = "./results/subjects.pdf", height = 4, width = 8)

## summary stat for works
work_author = gutenberg_works(all_languages = TRUE)%>%
  filter(!is.na(author), !(author %in% c("Various", "Anonymous", "Unknown"))) %>%
  group_by(author) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  mutate(lastname = gsub(pattern = ",.+", replacement = "", x = author))

work_author = work_author[1:20,]
work_author$lastname <- factor(work_author$lastname, levels=unique(work_author$lastname))

p_work_author = ggplot(data = work_author) +
  geom_bar(aes(x = lastname, y = n), stat = "identity", fill = "lightblue")+
  ylab(label = "No. books") +
  xlab(label = "Last name") +
  theme_light()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(p_work_author, filename = "./results/work_author.pdf", height = 4, width = 8)

## function
visualizeWordcloud <- function(term, freq, title = "", min.freq = 50, max.words = 200){
  mypal <- brewer.pal(8,"Dark2")
  wordcloud(words = term,
            freq = freq, 
            colors = mypal, 
            scale=c(8,.3),
            rot.per=.15,
            min.freq = min.freq, max.words = max.words,
            random.order = F)
}

## Mark Twain
works_MT = gutenberg_works(all_languages = TRUE) %>%
  filter(author == "Twain, Mark")
MT = gutenberg_download(works_MT, meta_fields = "title")

MT_words <- MT %>%
  mutate(LineNumber = row_number()) %>%
  unnest_tokens(word, text)

MT_words_clean <- MT_words %>%
  anti_join(stop_words)

MT_word_count <- MT_words_clean %>%
  count(word)

pdf('./results/MarkTwain.pdf')
visualizeWordcloud(term = MT_word_count$word, freq = MT_word_count$n, max.words = 100)
dev.off()

## Shakespeare
works_WS = gutenberg_works(all_languages = TRUE) %>%
  filter(author == "Shakespeare, William")
WS = gutenberg_download(works_WS, meta_fields = "title")

WS_words <- WS %>%
  mutate(LineNumber = row_number()) %>%
  unnest_tokens(word, text)

WS_words_clean <- WS_words %>%
  anti_join(stop_words)

WS_word_count <- WS_words_clean %>%
  count(word)

pdf('./results/Shakespeare.pdf')
visualizeWordcloud(term = WS_word_count$word, freq = WS_word_count$n, max.words = 100)
dev.off()

## Dickens
works_CD = gutenberg_works(all_languages = TRUE) %>%
  filter(author == "Dickens, Charles")
CD = gutenberg_download(works_CD, meta_fields = "title")

CD_words <- CD %>%
  mutate(LineNumber = row_number()) %>%
  unnest_tokens(word, text)

CD_words_clean <- CD_words %>%
  anti_join(stop_words)

CD_word_count <- CD_words_clean %>%
  count(word)

pdf('./results/Dickens.pdf')
visualizeWordcloud(term = CD_word_count$word, freq = CD_word_count$n, max.words = 100)
dev.off()

## prepare data set

df_MT = MT_words_clean %>%
  group_by(gutenberg_id) %>%
  count(word) %>%
  filter(n > 10) %>%
  mutate(AUTHOR = "MT")

df_WS = WS_words_clean %>%
  group_by(gutenberg_id) %>%
  count(word) %>%
  filter(n > 10) %>%
  mutate(AUTHOR = "WS")

df_CD = CD_words_clean %>%
  group_by(gutenberg_id) %>%
  count(word) %>%
  filter(n > 10) %>%
  mutate(AUTHOR = "CD")

df = rbind(df_MT, df_WS, df_CD) %>%
  spread(key = word, value = n, fill = 0)

write.csv(df, file = "./df.csv", row.names = FALSE)
