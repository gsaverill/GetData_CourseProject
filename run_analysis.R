###############################################################################
# R Script
#
# This script implements the required data gathering, tidying,
# and analyizing required for the course project.
# Class: Getting and Cleaning Data, Coursera Data Science Sequence
# 
# Author: G. S. Averill
###############################################################################


# The overall instructions for this assignment are:
#
# Create one R script called run_analysis.R that does the following:
#
#  1) Merges the training and the test sets to create one data set.
#
#  2) Extracts only the measurements on the mean and standard deviation 
#     for each measurement. 
#
#  3) Uses descriptive activity names to name the activities in the data set.
#
#  4) Appropriately labels the data set with descriptive variable names. 
#
#  5) From the data set in step 4, creates a second, independent tidy data 
#     set with the average of each variable for each activity and each subject.


library(dplyr)

# URL for the source data .zip archive.
sourceDataZipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Name of the local copy of the .zip archive.
zipFile <- "UCI_HAR_Dataset.zip"

# Set up variables with the names of the files to be found in the source data 
# archive.

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

# If the data directory isn't present locally, download the .zip archive (if
# it is not also present) and extract the data directory.
if (!file.exists(dataDir)) {
    if (!file.exists(zipFile)) {
        download.file(sourceDataZipURL, zipFile, method = "curl")
    } 
    unzip(zipFile)
    file.rename(dataDirRaw, dataDir)
}

# Massage the list of feature names to be unique, legal R variable names.
#   - strip out all instances of "()"
#   - change all "-"s to "."s
#   - change all ","s to "."s
#   - make all duplicate names unique and clean up the remaining "("s and ")"s
# These names will be used as the descriptive variable names for the columns of
# observation data to satisfy item (4) in the overall instructions.

features     <- read.table(featuresFile)
featureNames <- as.character(features$V2)
featureNames <- gsub("\\()", "", featureNames) 
featureNames <- gsub("-", ".", featureNames)   
featureNames <- gsub(",", ".", featureNames)   
featureNames <- gsub("BodyBody", "Body", featureNames)
featureNames <- make.names(featureNames, unique = TRUE)

# Read in the observations, subjects, and activities of the "test" dataset. 
# Combine into one dplyr data frame tbl.
# Add a column called Test_or_Train that remembers that this data came from
# the test dataset.

testObservations         <- read.table(testObservationsFile)
names(testObservations)  <- featureNames

testSubjects             <- read.table(testSubjectsFile)
names(testSubjects)      <- "Subject"

testActivities           <- read.table(testActivitiesFile)
names(testActivities)    <- "Activity"

testData <- tbl_df(cbind(testSubjects, testActivities, testObservations))
testData <- mutate(testData, Test_or_Train = "TEST")

# Read in the observations, subjects, and activities of the "training" dataset. 
# Combine into one dplyr data frame tbl.
# Add a column called Test_or_Train that remembers that this data came from
# the training dataset.

trainObservations        <- read.table(trainObservationsFile)
names(trainObservations) <- featureNames

trainSubjects            <- read.table(trainSubjectsFile)
names(trainSubjects)     <- "Subject"

trainActivities          <- read.table(trainActivitiesFile)
names(trainActivities)   <- "Activity"

trainData <- tbl_df(cbind(trainSubjects, trainActivities, trainObservations))
trainData <- mutate(trainData, Test_or_Train = "TRAIN")

# Combine the test and training datasets into one dplyr data frame tbl.
combinedData <- rbind_list(testData, trainData)

# In this combined dataset, choose only the subset of columns that contain 
# mean or standard deviation data, along with the Subject and Activity
# columns of course.  If one wanted to distinguish between test and training
# data, then uncomment the "Test_or_Train" selection as well.
combinedData <- select(combinedData, 
                     Subject, 
                     Activity, 
                     #Test_or_Train, 
                     contains(".mean"), 
                     -contains(".meanFreq"), 
                     contains(".std")
                    )

# Convert the Activity column to a factor.  Then, using the mappings in 
# the source file "activity_labels.txt", which are read into the data 
# frame named "activityLabels", remap the factor levels from numbers to 
# descriptive activity names.
#   "1" -> "WALKING"
#   "2" -> "WALKING_UPSTAIRS"
#   "3" -> "WALKING_DOWNSTAIRS"
#   "4" -> "WALKING_SITTING"
#   "5" -> "STANDING"
#   "6" -> "LAYING" (sic)

combinedData$Activity <- as.factor(combinedData$Activity)

activityLabels <- read.table(activityLabelsFile)

for (activity in activityLabels$V1) {
    num <- as.character(activity)
    name <- as.character(activityLabels$V2[activityLabels$V1 == num])

    # Remap the level for this activity from a number to a name.
    levels(combinedData$Activity)[levels(combinedData$Activity) == num] <- name
}

# For neatness, convert the Subject column to a factor.
combinedData$Subject <- as.factor(combinedData$Subject)

# At this point in the script, the dataset held in the "combinedData" data 
# frame table satisfies items 1-4 of the overall instructions.
#    1) The training and test data sets are merged and tidy.
#    2) Only the mean and standard deviation measurements are included.
#    3) The activity names are descriptive (WALKING, etc.)
#    4) The columns of observations have descriptive variable names.

# Now we'll use some chained dplyr functions to carryout step (5) of the 
# overall instructions, where we'll create a second tidy data set with 
# the average of each variable for each activity and each subject.  
#
# Group the data frame tbl by Subject and Activity.
# Then, by subject and by activity, take the mean of the each column of 
# observations.  Load into a new data frame tbl named "combinedAverageData".

combinedAverageData <- combinedData %>% 
                       group_by(Subject, Activity) %>%
                       summarise_each(funs(mean))

# Write this second dataset to a file called "combinedAverageData.txt".
write.table(combinedAverageData, 
            file = "combinedAverageData.txt", 
            row.name = FALSE
           )
