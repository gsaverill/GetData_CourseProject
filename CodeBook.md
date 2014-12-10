The data for this exercise is found in a zip archive at this URL:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A general description of the data is found at this URL:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

A more detailed description of the observed variables is found in the
features_info.txt file within the data archive.

Those two sources essentially comprise the code book for the original data.

In this project, the feature variable names were transformed so that they
would be legal names for R variables.

The transformation of variable names was:

   - All instances of "()" were removed
   - All "-" characters were converted to "." characers.
   - All "," characters were converted to "." characers.
   - All duplicate names were made unique by adding a suffix with a "."
     followed by an integer (e.g, the duplicate pair of names "example" and 
     "example" would be converted to "example" and "example.1").
   - All remaining instances of "(" and ")" were converted to "." characters.


So, for example, the original names in the left column were transformed into
the names in the right column:

fBodyAcc-mean()-X   =>   fBodyAcc.mean.X
fBodyAcc-mean()-Y   =>   fBodyAcc.mean.Y
fBodyAcc-mean()-Z   =>   fBodyAcc.mean.Z
fBodyAcc-std()-X    =>   fBodyAcc.std.X
fBodyAcc-std()-Y    =>   fBodyAcc.std.Y
fBodyAcc-std()-Z    =>   fBodyAcc.std.Z

The full set of 66 feature names in the datasets generated by run_analysis.R
are shown below.  These are the observations that capture mean and standard
deviation

fBodyAcc.mean.X
fBodyAcc.mean.Y
fBodyAcc.mean.Z
fBodyAcc.std.X
fBodyAcc.std.Y
fBodyAcc.std.Z
fBodyAccJerk.mean.X
fBodyAccJerk.mean.Y
fBodyAccJerk.mean.Z
fBodyAccJerk.std.X
fBodyAccJerk.std.Y
fBodyAccJerk.std.Z
fBodyAccMag.mean
fBodyAccMag.std
fBodyBodyAccJerkMag.mean
fBodyBodyAccJerkMag.std
fBodyBodyGyroJerkMag.mean
fBodyBodyGyroJerkMag.std
fBodyBodyGyroMag.mean
fBodyBodyGyroMag.std
fBodyGyro.mean.X
fBodyGyro.mean.Y
fBodyGyro.mean.Z
fBodyGyro.std.X
fBodyGyro.std.Y
fBodyGyro.std.Z
tBodyAcc.mean.X
tBodyAcc.mean.Y
tBodyAcc.mean.Z
tBodyAcc.std.X
tBodyAcc.std.Y
tBodyAcc.std.Z
tBodyAccJerk.mean.X
tBodyAccJerk.mean.Y
tBodyAccJerk.mean.Z
tBodyAccJerk.std.X
tBodyAccJerk.std.Y
tBodyAccJerk.std.Z
tBodyAccJerkMag.mean
tBodyAccJerkMag.std
tBodyAccMag.mean
tBodyAccMag.std
tBodyGyro.mean.X
tBodyGyro.mean.Y
tBodyGyro.mean.Z
tBodyGyro.std.X
tBodyGyro.std.Y
tBodyGyro.std.Z
tBodyGyroJerk.mean.X
tBodyGyroJerk.mean.Y
tBodyGyroJerk.mean.Z
tBodyGyroJerk.std.X
tBodyGyroJerk.std.Y
tBodyGyroJerk.std.Z
tBodyGyroJerkMag.mean
tBodyGyroJerkMag.std
tBodyGyroMag.mean
tBodyGyroMag.std
tGravityAcc.mean.X
tGravityAcc.mean.Y
tGravityAcc.mean.Z
tGravityAcc.std.X
tGravityAcc.std.Y
tGravityAcc.std.Z
tGravityAccMag.mean
tGravityAccMag.std

The features that start with "f" are frequency domain observations and those
that begin with "t" are time domain observations.  The X, Y, and Z suffixes
denote the three axial dimensions. All values are normalized and bounded
within [-1, 1].  The units for the observations of linear acceleration are
standard gravitational acceleration (g).  The units for the observations of
angular velocity are radians per second.

For more details on the feature variables, see the documents sited at the
beginning of this codebook for the original data.

The run_analysis.R script generates two data sets.

Here is what the combined data set looks like, selecting the first 10 rows
and only the first five columns:

   Subject Activity tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z
1        2 STANDING       0.2571778     -0.02328523     -0.01465376
2        2 STANDING       0.2860267     -0.01316336     -0.11908252
3        2 STANDING       0.2754848     -0.02605042     -0.11815167
4        2 STANDING       0.2702982     -0.03261387     -0.11752018
5        2 STANDING       0.2748330     -0.02784779     -0.12952716
6        2 STANDING       0.2792199     -0.01862040     -0.11390197
7        2 STANDING       0.2797459     -0.01827103     -0.10399988
8        2 STANDING       0.2746005     -0.02503513     -0.11683085
9        2 STANDING       0.2725287     -0.02095401     -0.11447249
10       2 STANDING       0.2757457     -0.01037199     -0.09977589

There are 68 columns in this dataset, including Subject, Activity, and 66
mean and standard deviation variables.  There are 10,299 rows.
There are 30 subjects, each representing a person, numbered 1-30.  There are
six activities that each subject engages in: 
	WALKING 
	WALKING_UPSTAIRS
	WALKING_DOWNSTAIRS
	SITTING
	STANDING
	LAYING 


In the second data set, the data is summarized, by subject and activity, with
the mean of each of the feature variable columns.  Here are the first 10 rows
and five columns of the second dataset:

   Subject           Activity tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z
1        1            WALKING       0.2773308    -0.017383819      -0.1111481
2        1   WALKING_UPSTAIRS       0.2554617    -0.023953149      -0.0973020
3        1 WALKING_DOWNSTAIRS       0.2891883    -0.009918505      -0.1075662
4        1            SITTING       0.2612376    -0.001308288      -0.1045442
5        1           STANDING       0.2789176    -0.016137590      -0.1106018
6        1             LAYING       0.2215982    -0.040513953      -0.1132036
7        2            WALKING       0.2764266    -0.018594920      -0.1055004
8        2   WALKING_UPSTAIRS       0.2471648    -0.021412113      -0.1525139
9        2 WALKING_DOWNSTAIRS       0.2776153    -0.022661416      -0.1168129
10       2            SITTING       0.2770874    -0.015687994      -0.1092183

There are 68 columns in this dataset, including Subject, Activity, and 66
mean and standard deviation variables.  There are 180 rows, which represent
six activities per subject for each of 30 subjects.