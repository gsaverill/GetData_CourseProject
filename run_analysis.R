###############################################################################
# R Script
#
# This script implements the required data gathering, tidying,
# and analyizing required for the course project.
# Class: Getting and Cleaning Data, Coursera Data Science Sequence
# 
# Author: G. S. Averill
###############################################################################

# URL for the source data .zip archive.
sourceDataZipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Directory and file names for the source data.
zipFile    <- "UCI_HAR_Dataset.zip"
dataDirRaw <- "UCI HAR Dataset" # the directory name within the archive
dataDir    <- "UCI_HAR_Dataset" # the directory name I prefer to use

activityLabelsFile    <- paste(dataDir, "/activity_labels.txt",     sep="")
featuresFile          <- paste(dataDir, "/features.txt",            sep="")

testObservationsFile  <- paste(dataDir, "/test/X_test.txt",         sep="")
testSubjectsFile      <- paste(dataDir, "/test/subject_test.txt",   sep="")
testActivitiesFile    <- paste(dataDir, "/test/y_test.txt",         sep="")

trainObservationsFile <- paste(dataDir, "/train/X_train.txt",       sep="")
trainSubjectsFile     <- paste(dataDir, "/train/subject_train.txt", sep="")
trainActivitiesFile   <- paste(dataDir, "/train/y_train.txt",       sep="")

# If the data directory isn't available locally, download the .zip archive (if
# it is not also present) and extract the data directory.
if (!file.exists(dataDir)) {
    if (!file.exists(zipFile)) {
        download.file(sourceDataZipURL, zipFile, method = "curl")
    } 
    unzip(zipFile)
    file.rename(dataDirRaw, dataDir)
}

library(dplyr)
library(tidyr)

# Read the data files and convert the data frames to data frame tbls.
activityLabels <- read.table(activityLabelsFile)

# Massage the list of feature names to be unique, legal R variable names
#   - strip out all instances of "()"
#   - change all "-"s to "."s
#   - change all ","s to "."s
#   - make all duplicate names unique and clean up the remaining "("s and ")"s
#   
features     <- read.table(featuresFile)
featureNames <- (as.character(features$V2))    
featureNames <- gsub("\\()", "", featureNames) 
featureNames <- gsub("-", ".", featureNames)   
featureNames <- gsub(",", ".", featureNames)   
featureNames <- make.names(featureNames, unique = TRUE)

# test

testObservations         <- read.table(testObservationsFile)
names(testObservations)  <- featureNames

testSubjects             <- read.table(testSubjectsFile)
names(testSubjects)      <- "Subject"

testActivities           <- read.table(testActivitiesFile)
names(testActivities)    <- "Activity"

testData <- tbl_df(cbind(testSubjects, testActivities, testObservations))
testData <- mutate(testData, Test_or_Train = "TEST")

# train

trainObservations        <- read.table(trainObservationsFile)
names(trainObservations) <- featureNames

trainSubjects            <- read.table(trainSubjectsFile)
names(trainSubjects)     <- "Subject"

trainActivities          <- read.table(trainActivitiesFile)
names(trainActivities)   <- "Activity"

trainData <- tbl_df(cbind(trainSubjects, trainActivities, trainObservations))
trainData <- mutate(trainData, Test_or_Train = "TRAIN")

# combined

combinedData <- rbind_list(testData, trainData)

combinedData <- select(combinedData, 
                     Subject, 
                     Activity, 
                     #Test_or_Train, 
                     contains(".mean"), 
                     contains(".std")
                    )

# Convert the Activity column to a factor.
combinedData$Activity <- as.factor(combinedData$Activity)

# Remap the factor levels to reflect the activity names.
levels(combinedData$Activity)[levels(combinedData$Activity)=="1"] <- 
                                                            "WALKING"
levels(combinedData$Activity)[levels(combinedData$Activity)=="2"] <- 
                                                            "WALKING_UPSTAIRS"
levels(combinedData$Activity)[levels(combinedData$Activity)=="3"] <- 
                                                            "WALKING_DOWNSTAIRS"
levels(combinedData$Activity)[levels(combinedData$Activity)=="4"] <- 
                                                            "SITTING"
levels(combinedData$Activity)[levels(combinedData$Activity)=="5"] <- 
                                                            "STANDING"
levels(combinedData$Activity)[levels(combinedData$Activity)=="6"] <- 
                                                            "LAYING"

#

nData <- combinedData %>% 
         group_by(Subject, Activity) %>% 
         summarise_each(funs(mean))
