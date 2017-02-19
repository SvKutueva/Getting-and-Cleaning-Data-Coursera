#Download file:
        
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")

#Unzip files and set working directory.

unzip(zipfile = "./data1/Dataset1.zip", exdir = "./data1")
path_rf <- file.path("./data1" , "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

# Reading files:

ActivityTestData  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ), header = FALSE)
ActivityTrainData <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)
SubjectTrainData <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
SubjectTestData  <- read.table(file.path(path_rf, "test" , "subject_test.txt"), header = FALSE)
FeaturesTestData  <- read.table(file.path(path_rf, "test" , "X_test.txt" ), header = FALSE)
FeaturesTrainData <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)
activity_labels <- read.table(file.path(path_rf, "activity_labels.txt")
features <- read.table(file.path(path_rf, "features.txt")
                       
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

# Extracting only the measurements on the mean and standard deviation for each measurement:
        
subsetFeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames <- c(as.character(subsetFeatures), "subject", "activity")
subsetData <- subset(AllData, select = selectedNames)

# Creating tidy data:
        
library(plyr)
Data2 <- aggregate(. ~ subject + activity, subsetData, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity), ]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)