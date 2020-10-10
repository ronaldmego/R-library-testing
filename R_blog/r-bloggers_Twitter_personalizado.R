#------------------------------------------------------
#USING R TO COLLECT TWITTER DATA
#------------------------------------------------------
#https://personxsituation.wordpress.com/2016/03/31/using-r-to-collect-twitter-data/
#install.packages('twitteR')
library("twitteR")
#------------------------------------------------------
#Collecting Twitter Data in R:
#------------------------------------------------------

#You first need to setup your authorization to access Twitter data. This is where those 4 keys/codes come in.
#------------------------------------------------------
#Create object of each of the 4
consumerKey <- 'xxxxx'
consumerSecret <- 'xxxxx'
accessToken <- 'xxxx'
accessSecret <- 'xxxx'

#Then pass them through the authorization function
#scroll right to see whole thing
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessSecret)
#I think it will ask you what type of authorization. I chose direct.
#------------------------------------------------------
#I then created an object containing the Twitter Handles of my participants. 
#For the purpose of this example, I'm using my handle as well as those of some organization 
#accounts and one private account.
#------------------------------------------------------
#Otras librerias para extraer data
library("rvest")
#So, I could just write the names of twitter's 10 most followed world leaders, 
#but what would be the fun in that? We're going to scrape them from twiplomacy 
#using rvest and a chrome extension called selector gadget:
#help(lookup_users)
world_leaders = read_html("https://twiplomacy.com/ranking/the-50-most-followed-world-leaders-in-2017/")
lead_r = world_leaders %>% 
  html_nodes(".ranking-entry .ranking-user-name") %>%
  html_text() %>%
  str_replace_all("\\t|\\n|@", "")
head(lead_r)
#The string inside html_nodes() is gathered using selector gadget. 
#See this great tutorial on rvest and for more on selector gadget read vignette("selectorgadget"). 
#Tabs (\t) and linebreaks (\n) are removed with str_replace_all() from the stringr package.
#lead_r_info = lookupusers(lead_r[1:10])
#------------------------------------------------------
#Create data frame
data <- data.frame(ID = c(1,2,3,4,5,6), screenName = c('rmegos99','realDonaldTrump','Pontifex','narendramodi','PMOIndia','POTUS'), stringsAsFactors = F)
#------------------------------------------------------
#I next want twitteR to collect information about all of the handles at once. So I create two lists: 
#one of the participant "IDs" and one of the Twitter handles.
#------------------------------------------------------
participants <- as.list(data$ID)
usernames <- as.list(data$screenName)
#------------------------------------------------------
#Before collecting user information, you should make sure all the handles are real Twitter accounts, 
#otherwise you'll get an error.
#------------------------------------------------------
checkHandles <- lookupUsers(usernames)
#help(lookupUsers)
#------------------------------------------------------
#Now you can collect the account information. I've notated the below code to describe each of the steps I'm taking.
#------------------------------------------------------
#For each of the handles on the list, get user data
UserData <- lapply(checkHandles, function(x) getUser(x))

#Take the list and make it a data.frame
UserData <- twListToDF(UserData)

#Now make a list of the handles of only accounts that are public
usernames <- subset(UserData, protected == FALSE)
usernames <- as.list(usernames$screenName)
#------------------------------------------------------

#Collect the first two people's tweets
#We chose to include retweets; the default is not to
x <- lapply(usernames[1:2], function(x) userTimeline(x,n=3200,includeRts = TRUE))

#Make each into a dataframe
y1 <- lapply(x,function(x) twListToDF(x))

#Wait 5 minutes (300 seconds)
Sys.sleep(300)

#Now the last 3 people
x <- lapply(usernames[3:5], function(x) userTimeline(x,n=3200,includeRts = TRUE))

#Make each into a dataframe
y2 <- lapply(x,function(x) twListToDF(x))

#Now create a dataframe that combines all of the collected tweets
#First create empty dataframe
tweets <- data.frame()

#Then loop over both of the lists we've created,
#adding each person's tweets to the dataframe as we go
for(n in 1:2){
  tweets <- rbind(tweets,y1[[n]])
}
for(n in 1:3){
  tweets <- rbind(tweets,y2[[n]])
}

#Save users data and tweets data as csv files:
write.csv(UserData, 'Users.csv', row.names=F)
write.csv(tweets, 'Tweets.csv', row.names=F)

#clear environment
rm(list=ls())

#Now you should have a data frame with the tweets from all 5 accounts.