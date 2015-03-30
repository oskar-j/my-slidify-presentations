library(sqldf)
library(plyr)
library(rCharts)

swear_words <- read.csv("C:/big data/swearing.csv")
names(dialogues)
names(swear_words)[1] <- "entry"
names(swear_words)
# which(apply(dialogues, "body", function(x) any(grepl("a", x))))

swear_words$entry <- as.character(swear_words$entry)
swear_matched <- sqldf("select * from dialogues_n_users where body like '%fuck%';")
short.date = strftime(swear_matched$created_at, "%Y/%m")
count_swear_dates <- count(short.date)

n1 <- rPlot(freq ~ x, data = count_swear_dates, type = "point")
n1
n1$print("chart_swear_words")
