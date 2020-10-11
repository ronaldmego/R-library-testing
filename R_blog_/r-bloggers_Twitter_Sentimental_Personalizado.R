#----------------------------------------------------------------------------
#Tap Water Sentiment Analysis using Tidytext
#https://r.prevos.net/tap-water-sentiment-analysis/
#----------------------------------------------------------------------------
#Context: Tap Water Sentiment Analysis
#Each tweet that contains the words "tap water" contains a message about the attitude the author has 
#towards that topic. Each text expresses a sentiment about the topic it describes. 
#Sentiment analysis is a data science technique that extracts subjective information from a text. 
#The basic method compares a string of words with a set of words with calibrated sentiments. 
#These calibrated sets are created by asking many people how they feel about a certain word. 
#For example, the word "stink" expresses a negative sentiment, while the word "nice" would be a positive sentiment.
#----------------------------------------------------------------------------
#This tap water sentiment analysis consists of three steps. The first step extracts 1000 tweets 
#that contain the words "tap water" from Twitter. The second step cleans the data, and the third 
#step undertakes the analysis visualises the results.
#----------------------------------------------------------------------------
#(1)Extracting tweets using the TwitteR package
#----------------------------------------------------------------------------
#The TwitteR package by Geoff Gentry makes it very easy to retrieve tweets using search criteria. 
#You will need to create an API on Twitter to receive the keys and tokens. In the code below, 
#the actual values have been removed. Follow the instructions in this article to obtain these codes for yourself. 
#This code snippet calls a private file to load the API codes, extracts the tweets and creates a data frame 
#with a tweet id number and its text.
#----------------------------------------------------------------------------
# Init
library(tidyverse)
library(tidytext)
library(twitteR)
#----------------------------------------------------------------------------
#Credenciales
#----------------------------------------------------------------------------
consumerKey <- 'Txxxjkv'
consumerSecret <- 'UxxxN'
accessToken <- '383532xxxE7XefW'
accessSecret <- 'yroMxxxxx81P5M'
#----------------------------------------------------------------------------
# Extract tap water tweets
#source("twitteR_API.R")
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessSecret)
xtw_tweets <- searchTwitter("Siria", n = 1000, lang = "en") %>%
  twListToDF() %>%
  select(id, text)
xtw_tweets <- subset(xtw_tweets, !duplicated(xtw_tweets$text))
xtw_tweets$text <- gsub("'", "'", xtw_tweets$text)
#write_csv(xtw_tweets, "D:/OneDrive/UNI/R-CRAN Ronald Mego/xtw_tweets.csv")
#----------------------------------------------------------------------------
#When I first extracted these tweets, a tweet by CNN about tap water in Kentucky 
#that smells like diesel was retweeted many times, so I removed all duplicate tweets from the set. 
#Unfortunately, this left less than 300 original tweets in the corpus.
#----------------------------------------------------------------------------
#(2)DATA CLEANINGS
#----------------------------------------------------------------------------
#Text analysis can be a powerful tool to help to analyse large amounts of text. 
#The R language has an extensive range of packages to help you undertake such a task. 
#The Tidytext package extends the Tidy Data logic promoted by Hadley Wickham and his Tidyverse software collection.
#----------------------------------------------------------------------------
#The first step in cleaning the data is to create unigrams, which involves splitting the 
#tweets into individual words that can be analysed. The first step is to look at which words 
#are most commonly used in the tap water tweets and visualise the result.
#----------------------------------------------------------------------------
# Tokenisation
tidy_tweets <- xtw_tweets %>%
  unnest_tokens(word, text)

data(stop_words)
tidy_tweets <- tidy_tweets %>%
  anti_join(stop_words) %>%
  filter(!word %in% c("Siria","rt", "https","t.co", as.character(0:9)))

tidy_tweets %>%
  count(word, sort = TRUE) %>%
  filter(n > 5) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) + geom_col(fill = "dodgerblue4") +
  xlab(NULL) + coord_flip() + ggtitle("Most common words in Siria topic")
#ggsave("D:/xxxx.png", dpi = 300)
#----------------------------------------------------------------------------
#The most common words related to drinking the water and to bottled water, which makes sense. 
#Also the recent issues in Kentucky feature in this list.
#----------------------------------------------------------------------------
#(3)Sentiment analysis
#----------------------------------------------------------------------------
#The Tidytext package contains three lexicons of thousands of single English words (unigrams) 
#that were manually assessed for their sentiment. The principle of the sentiment analysis 
#is to compare the words in the text with the words in the lexicon and analyse the results. 
#For example, the statement: "This tap water tastes horrible" has a sentiment score of -3 in 
#the AFFIN system by Finn Årup Nielsen due to the word "horrible". In this analysis, 
#I have used the "bing" method published by Liu et al. in 2005.
#----------------------------------------------------------------------------
sentiment_bing <- tidy_tweets %>%
  inner_join(get_sentiments("bing"))
#help(get_sentiments)
#translateR package como posible solución
sentiment_bing %>%
  summarise(Negative = sum(sentiment == "negative"), 
            positive = sum(sentiment == "positive"))
sentiment_bing %>%
  group_by(sentiment) %>%
  count(word, sort = TRUE) %>%
  filter(n > 2) %>%
  ggplot(aes(word, n, fill = sentiment)) + geom_col(show.legend = FALSE) + 
  coord_flip() + facet_wrap(~sentiment, scales = "free_y") + 
  ggtitle("Contribution to sentiment") + xlab(NULL) + ylab(NULL)
#ggsave("D:/xxxx.png", dpi = 300)
#----------------------------------------------------------------------------
#This tap water sentiment analysis shows that two-thirds of the words that express a sentiment were negative. The most common negative words were "smells" and "scared". This analysis is not a positive result for water utilities. Unfortunately, most tweets were not spatially located so I couldn't determine the origin of the sentiment.