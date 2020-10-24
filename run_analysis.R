library (data.table)
library(dplyr)
library (stringr)
library (reshape2)

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

train <- fread (file.path (directory, "UCI HAR Dataset/train/X_train.txt" )) [, featureWant, with = FALSE]
data.table::setnames(train, colnames(train), measurement)
trainActivity <- fread(file.path(directory, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trainSubject <- fread(file.path(directory, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
trainBodyAccX <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_acc_x_train.txt"))
trainBodyAccY <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_acc_y_train.txt"))
trainBodyAccZ <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_acc_z_train.txt"))
trainBodyGyroX <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_gyro_x_train.txt"))
trainBodyGyroY <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_gyro_y_train.txt"))
trainBodyGyroZ <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/body_gyro_z_train.txt"))
trainTotalAccX <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/total_acc_x_train.txt"))
trainTotalAccY <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/total_acc_y_train.txt"))
trainTotalAccZ <- fread(file.path(directory, "UCI HAR Dataset/train/Inertial_Signals/total_acc_z_train.txt"))
train <- cbind(trainSubject, trainActivity, train)
censor_train_XYZ <- rbind (trainBodyAccX, trainBodyAccY, trainBodyAccZ, trainBodyGyroX, trainBodyGyroY, trainBodyGyroZ,
                          trainTotalAccX, trainTotalAccY, trainTotalAccZ)

##load the test data

test <- fread (file.path (directory, "UCI HAR Dataset/test/X_test.txt" )) [, featureWant, with = FALSE]
data.table::setnames(test, colnames(test), measurement)
testActivity <- fread(file.path(directory, "UCI HAR Dataset/test/Y_test.txt")
                          , col.names = c("Activity"))
testSubject <- fread(file.path(directory, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
testBodyAccX <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_acc_x_test.txt"))
testBodyAccY <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_acc_y_test.txt"))
testBodyAccZ <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_acc_z_test.txt"))
testBodyGyroX <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_gyro_x_test.txt"))
testBodyGyroY <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_gyro_y_test.txt"))
testBodyGyroZ <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/body_gyro_z_test.txt"))
testTotalAccX <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/total_acc_x_test.txt"))
testTotalAccY <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/total_acc_y_test.txt"))
testTotalAccZ <- fread(file.path(directory, "UCI HAR Dataset/test/Inertial_Signals/total_acc_z_test.txt"))
test <- cbind(testSubject, testActivity, test)
censor_test_XYZ <- rbind (testBodyAccX, testBodyAccY, testBodyAccZ, testBodyGyroX, testBodyGyroY, testBodyGyroZ,
                          testTotalAccX, testTotalAccY, testTotalAccZ)


## merge the data
DataCompile <- rbind (train, test, fill = TRUE)

##cleaning the data

DataCompile[["SubjectNum"]] <- as.factor(DataCompile[, SubjectNum])
DataCompile <- data.table::melt(data = DataCompile, id = c("SubjectNum", "Activity"))
DataCompile <- data.table::dcast(data = DataCompile, SubjectNum + Activity ~ variable, fun.aggregate = mean)
