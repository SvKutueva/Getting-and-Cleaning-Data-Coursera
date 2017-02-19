#Download file:
        
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")

#Unzip files and set working directory.

unzip(zipfile = "./data/Dataset.zip", exdir = "./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

# Reading files:

ActivityTestData  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ), header = FALSE)
ActivityTrainData <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)
SubjectTrainData <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
SubjectTestData  <- read.table(file.path(path_rf, "test" , "subject_test.txt"), header = FALSE)
FeaturesTestData  <- read.table(file.path(path_rf, "test" , "X_test.txt" ), header = FALSE)
FeaturesTrainData <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)
activity_labels <- read.table(file.path(path_rf, "activity_labels.txt"))
features <- read.table(file.path(path_rf, "features.txt"))
                       
# Merging data:
                               
ActivityData <- rbind(ActivityTestData, ActivityTrainData)
SubjectData <- rbind(SubjectTestData, SubjectTrainData)
FeaturesData <- rbind(FeaturesTestData, FeaturesTrainData)
                       
# Setting names of variables:
                               
names(SubjectData) <- c("subject")
names(ActivityData) <- c("activity")
names(FeaturesData) <- features$V2

# Merging all data:
dataCombine <- cbind(SubjectData, ActivityData)
AllData <- cbind(FeaturesData, dataCombine)

# replace activity values with named factor levels:
AllData$activity <- factor(AllData$activity, levels = activity_labels[, 1], labels = activity_labels[, 2])


# Using descriptive variable names:
names(AllData) <-gsub("^t", "time", names(AllData))
names(AllData) <-gsub("^f", "frequency", names(AllData))
names(AllData) <-gsub("Acc", "Accelerometer", names(AllData))
names(AllData) <-gsub("Gyro", "Gyroscope", names(AllData))
names(AllData) <-gsub("Mag", "Magnitude", nameDatas(AllData))
names(AllData) <-gsub("BodyBody", "Body", names(AllData))

# check:

names(AllData)

# Extracting only the measurements on the mean and standard deviation for each measurement:
        
subsetFeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames <- c(as.character(subsetFeatures), "subject", "activity")
subsetData <- subset(AllData, select = selectedNames)

# Creating tidy data:
        
library(dplyr)
tidyData <- aggregate(. ~ subject + activity, AllData, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity), ]
write.table(tidyData, file = "tidydata.txt",row.name = FALSE)