library(devtools)
library(vosonSML)
library(magrittr) 
library(tuber)
library(dplyr)
library(ggplot2)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer") 
library(tidytext)
library(tidyverse)

#getting the comments from youtube
api_key <-"AIzaSyBoFu--BlL98CQYRSqdmROiq7cR48kh0a8"
youtubeAuth <- Authenticate("youtube", apiKey = api_key)
video <- c('wIpbiBaEw_8')
ptm <- proc.time()


youtubeData <- youtubeAuth %>% 
               Collect(videoIDs = video, writeToFile = TRUE, verbose = FALSE, maxComments = 3000)
proc.time() - ptm

#reading the data

data <- read.csv('/home/siddhu/Desktop/Hons 2/data/out8.csv',header = TRUE)
data <- data[data$ReplyToAnotherUser != FALSE,]
y <- data.frame(data$User,data$ReplyToAnotherUser)

#create user network

library(igraph)
net<- graph.data.frame(y,directed=T)
net <- simplify(net)
V(net)
E(net)
V(net)$label <- V(net)$name
V(net)$degree <- degree(net)


#Histogram of node degree

hist(V(net)$degree,col='green',main="Histogram of Node Degree",ylab = 'Freaquency',xlab = 'Degree of vertices')

#network Diagram

plot(net,vertex.size= 0.2*V(net)$degree,edge.arrow.size=0.1,vertex.label.cex=0.1*V(net)$degree)



#sentiment analysis

library(syuzhet)

app_id <- "555979129602-39mrhk9rhuoe1lnan87fna5dl9r4k1ce"
app_secret<-"m4vdXgWX0d0EXw-CJK8BOmiD"

yt_oauth(app_id, app_secret,token='')
t<-get_stats(video_id="Qsvy10D5rtc")


barplot(100*colSums(s)/sum(s),las =2,col=rainbow(10),ylab = "percentage",main="sentiment scores of youtube comments")


#sentiment_analysis


data <- read.csv('/home/siddhu/Desktop/Hons 2/data/out6.csv',header = TRUE)

comments <- iconv(data$Comment ,to = 'UTF-8')


ptm <- proc.time()

s <- get_nrc_sentiment(comments)



proc.time() - ptm

head(s)

s$neutral <-ifelse(s$negative+s$positive==0,1,0)


barplot(250*colSums(s)/sum(s),las =2,col=rainbow(10),ylab = "percentage",main="sentiment scores of youtube comments")



#Get statistics of all the videos in a channel


a <- list_channel_resources(filter = c(channel_id = "UCT5Cx1l4IS3wHkJXNyuj4TA"), part="contentDetails")
playlist_id <- a$items[[1]]$contentDetails$relatedPlaylists$uploads
vids <- get_playlist_items(filter= c(playlist_id=playlist_id)) 
vid_ids <- as.vector(vids$contentDetails.videoId)
get_all_stats <- function(id) {
  get_stats(id)
}
res <- lapply(vid_ids, get_all_stats)
res_df <- do.call(rbind, lapply(res, data.frame))

head(res_df)





