GetData_CourseProject
=====================

The run_analysis.R script implements the required data gathering, tidying,
and analyzing required for the course project in the Getting and Cleaning
Data course in the Coursera Data Science Sequence.

The overall instructions for this assignment are to create one R script 
called run_analysis.R that does the following:
<ol>
<li>Merges the training and the test sets to create one data set. </li>
<li>Extracts only the measurements on the mean and standard deviation 
for each measurement. </li>
<li>Uses descriptive activity names to name the activities in the data
set.</li>
<li>Appropriately labels the data set with descriptive variable names. </li>
<li>From the data set in step 4, creates a second, independent tidy data 
set with the average of each variable for each activity and each
subject. </li>
</ol>

The script is fully self-contained with respect to the source data in that if
the data directory is not found in the working directory, then the script will
download the data zip archive from the source URL and unzip it.

The URL that has the data for the project is:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The name of the data directory when extracted from the zip archive is "UCI
HAR Dataset".  I prefer to not have directory names with embedded white
space, so this script renames the data directory to be: "UCI_HAR_Dataset"

The directory and files found in the data set are structured like this:

UCI HAR Dataset
	/activity_labels.txt
	/features.txt
	/features_info.txt
	/README.txt
	/test
	/test/Inertial Signals
	/test/Inertial Signals/body_acc_x_test.txt
	/test/Inertial Signals/body_acc_y_test.txt
	/test/Inertial Signals/body_acc_z_test.txt
	/test/Inertial Signals/body_gyro_x_test.txt
	/test/Inertial Signals/body_gyro_y_test.txt
	/test/Inertial Signals/body_gyro_z_test.txt
	/test/Inertial Signals/total_acc_x_test.txt
	/test/Inertial Signals/total_acc_y_test.txt
	/test/Inertial Signals/total_acc_z_test.txt
	/test/subject_test.txt
	/test/X_test.txt
	/test/y_test.txt
	/train
	/train/Inertial Signals
	/train/Inertial Signals/body_acc_x_train.txt
	/train/Inertial Signals/body_acc_y_train.txt
	/train/Inertial Signals/body_acc_z_train.txt
	/train/Inertial Signals/body_gyro_x_train.txt
	/train/Inertial Signals/body_gyro_y_train.txt
	/train/Inertial Signals/body_gyro_z_train.txt
	/train/Inertial Signals/total_acc_x_train.txt
	/train/Inertial Signals/total_acc_y_train.txt
	/train/Inertial Signals/total_acc_z_train.txt
	/train/subject_train.txt
	/train/X_train.txt
	/train/y_train.txt


The data is divided into two sets, test and train.

The "Inertial Signals" files, which have no column names, I choose to ignore
since the data included is not part of the mean and standard deviation data
that will be selected for inclusion in the two data sets that are created in
this exercise.  For justification in making this assumption, I would cite
this course forum thread, under the heading "Do we need the inertial
folder":
https://class.coursera.org/getdata-016/forum/thread?thread_id=50

The list of variable names for the observation data is contained in the
feature.txt file. The names cannot be used directly as descriptive names for
the columns of observation data because they contain symbols that are not
legal in R names. So, the script transforms the raw names by

   - stripping out all instances of "()"
   - changing all occurances of "-" to "."
   - changing all occurances of "," to "."
   - making all duplicate names unique by adding a numerical suffix

Having been thus transformed, these names will be used as the descriptive
variable names for the columns of observation data to satisfy item (4) from
the overall instructions.

For each of the two data sets, train and test, the subjects, the
activities, and the feature data observations are read into separate data
frames from the subject_test.txt, y_test.txt, and X_test.txt files
respectively.  The cleaned up feature names are added as names for the
observations data frame.  The names of the subject and activity data frames
are changed to "Subject" and "Activity".  Then the three data frames for each
data set are column bound into a single dplyr data frame tbl.  Then, each of
those data frame tbls has a new column added that marks whether the data
belongs to the train or the test data set.  This new Test_or_Train column
isn't needed for this exercise, but it may be of use if one wanted to know
which data set a particular observation came from.

Then, the two data frame tbls are row bound into a single dplyr data frame
tbl.

Then, the mean and standard deviation data only is selected. This is done by
selecting names that contain ".mean" and ".std" (prior to transformation,
those name fragments would have been "-mean()" and "-std()").  
Using this criteria, There are 66 mean and standard deviation variables.

Note that I chose to exclude names that contain "meanFreq".  This is a
somewhat arbitrary choice, but I assumed that the names with mean() and std()
were what was wanted in the instructions.  If one wanted to not exclude
meanFreq() data, then it is trival to remove the '-contains(".meanFreq")'
argument to the select call in the R script.  

Next, the activity names are remapped to include descriptive names.  This is
done by remapping the factor levels.  Here is the remapping:

* "1" -> "WALKING"
* "2" -> "WALKING_UPSTAIRS"
* "3" -> "WALKING_DOWNSTAIRS"
* "4" -> "WALKING_SITTING"
* "5" -> "STANDING"
* "6" -> "LAYING"

At this point in the script, the dataset held in the "combinedData" data 
frame table satisfies items 1-4 of the overall instructions.
<ol>
<li>The training and test data sets are merged and tidy.
<li>Only the mean and standard deviation measurements are included.
<li>The activity names are descriptive (WALKING, etc.)
<li>The columns of observations have descriptive variable names.
</ol>

The dataset, in wide form, is tidy because 1) each variable measured is in
one column and 2) each different observation of that variable is in a
different row.

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

A chained sequence of dplyr commands is then used for step (5) of the overall
instructions, where we'll create a second tidy data set with the average of
each variable for each activity and each subject.  The dplyr group_by()
function is used to group the dataset by both Subject and Activity.  The
dplyr sumarise_each() function is then used to take the mean of all of the
observed variables, summarizing each by both subject and activity.  Here are
the first 10 rows and five columns of the second dataset:

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

This second dataset is then written out to a file called
"combinedAverageData.txt".

The file can be read back into R and viewed with these commands:

dataFromFile <- read.table("combinedAverageData.txt", header = TRUE)
View(dataFromFile)
