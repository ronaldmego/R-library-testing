#------------------------------------------------------
#USING R TO COLLECT TWITTER DATA
#------------------------------------------------------
#https://personxsituation.wordpress.com/2016/03/31/using-r-to-collect-twitter-data/
#install.packages('twitteR')
library("twitteR")
#/We (the Personality & Well-Being Lab at MSU) are currently conducting a study in which we are collecting the tweets of our Twitter-using participants. The learning curve for me to actually do this in R was a bit steep, so I thought I'd share what I've learned here. I'll do my  best to make this a sort of 'guide' for other researchers because I really feel as though more researchers should incorporate online behavior data into their work.

#Here are the steps I went through. I'll also include comments on methodological decisions we had to make when designing our study.

#Preliminary Steps:
  
#In order to collect data from Twitter, you first need to register an API (Application Programming Interface). (Note that you need to be signed into an existing Twitter account to do this. Additionally, your Twitter account needs to have an associated mobile phone number. This can be added in the account settings in the "Mobile" section.)
#Click on 'Create New App'.
#Fill in the Name, Description, and Website. For our purposes, these are not all that important because we did not use an app to collect the Tweets. For the name, we used something like "WBLabResearch". This may take a couple of tries because the name cannot have been used before.
#Select "Yes, I agree" and click the 'create' button.
#You will be taken to a page about your new 'app.' Click on the 'Keys and Access Tokens' tab.
#You will extract 4 things from this page. I copy/pasted them right into R, but it may be worthwhile for you to save them elsewhere. You will first need the Consumer/API Key and the Consumer/API Secret. Then scroll down and click on "Create my access token". You will also need the Access Token and Access Token Secret.
#That's it for this part.
#Download the 'twitteR' package in R. If you don't already have R, you'll need to get that first. Instructions for doing that can be found elsewhere. I use RStudio, so I apologize if any of my instructions are RStudio specific.

#------------------------------------------------------
#Collecting Twitter Data in R:
#------------------------------------------------------

#You first need to setup your authorization to access Twitter data. This is where those 4 keys/codes come in.
#------------------------------------------------------
#Create object of each of the 4
consumerKey <- 'xxxx'
consumerSecret <- 'xxxx'
accessToken <- 'xxxx'
accessSecret <- 'xxxxx'

#Then pass them through the authorization function
#scroll right to see whole thing
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessSecret)
#I think it will ask you what type of authorization. I chose direct.
#------------------------------------------------------
#I then created an object containing the Twitter Handles of my participants. 
#For the purpose of this example, I'm using my handle as well as those of some organization 
#accounts and one private account.
#------------------------------------------------------
#Create data frame
data <- data.frame(ID = c(13,46,33,15,5,10), screenName = c('cmtweten','SPSPJobs','OSFramework','michiganstateu','JohnJost1','SPSPnews'), stringsAsFactors = F)
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