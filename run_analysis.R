library (data.table)
library(dplyr)
library (stringr)

##download the data and unzip it

directory <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(directory, "data.zip"))
unzip (zipfile = "data.zip")

##load the activity labels
activityLabels <- fread(file.path(directory, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("indexLabels", "activityName"))
features <- fread(file.path(directory, "UCI HAR Dataset/features.txt")
                  , col.names = c("featureIndex", "featureNames"))
featureWant <- grep("(mean|std)\\(\\)", features[, featureNames])
measurement <- features[featureWant, featureNames]
measurement <- gsub('[()]', '', measurement)

##load the train data

