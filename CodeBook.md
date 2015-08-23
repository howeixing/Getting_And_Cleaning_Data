CodeBook
---------------------------------------------------------------
This document is used to describes the data and transofrmations used by *run_analysis.R* and also the definition of variables in *Tidy.txt*.

##Dataset Used:

This data is obtained from "Human Activity Recognition Using Smartphones Data Set". The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

The data set used can be downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. 

##Input Dataset:

The input data has the following data files:

- `X_train.txt`         -includes variable features that are intended for training.
- `y_train.txt`         -includes the activities corresponding to `X_train.txt`.
- `subject_train.txt`   -includes information on the subjects from whom data is collected.
- `X_test.txt`          -includes variable features that are intended for testing.
- `y_test.txt`          -includes the activities corresponding to `X_test.txt`.
- `subject_test.txt`    -includes information on the subjects from whom data is collected.
- `activity_labels.txt` -includes metadata on the different types of activities.
- `features.txt`        -includes the name of the features in the data sets.

##Transformations:

The transformations below are performed by the created R script (run_analysis.R):- 

The input dataset has to be formatted based on subject, activity and features.

The data is loaded as per below:

- `X_train.txt` is loaded into `featuresTrain`.
- `y_train.txt` is loaded into `activityTrain`.
- `subject_train.txt` is loaded into `subjectTrain`.
- `X_test.txt` is loaded into `featuresTest`.
- `y_test.txt` is loaded into `activityTest`.
- `subject_test.txt` is loaded into `subjectTest`.
- `features.txt` is loaded into `featureNames`.
- `activity_labels.txt` is loaded into `activityLabels`.

The input dataset is formatting and merged into a new dataset called 'completeData'as per below:

- The subjects in training and test set data are merged to form `subject`.
- The activities in training and test set data are merged to form `activity`.
- The features of test and training are merged to form `features`.
- The name of the features are set in `features` from `featureNames`.
- `features`, `activity` and `subject` are merged to form `completeData`.

The following activities are used to extract the only required data from 'completeData' and to correct the column label with appropriate description.

- Indices of columns that contain standard deviation or mean, activity and subject are taken into `requiredColumns`.
- `Extracted_Data` is created with data from columns in `requiredColumns`.
- `Activity` column in `Extracted_Data` is updated with descriptive names of activities taken from `activityLabels`. `Activity` column is expressed as a factor variable.
- Acronyms in variable names in `Extracted_Data`, like 'Acc', 'Gyro', 'Mag', 't' and 'f' are replaced with descriptive labels such as 'Accelerometer', 'Gyroscpoe', 'Magnitude', 'Time' and 'Frequency'.

A final dataset is created with average of eachh respective activity and subject in 'Extracted_Data' as below:

- Entries in `tidy_Data_average` are arranged in a sequence based on activity and subject.
- Lastly, the data in `tidy_Data_average` is generated as a output text file called *Tidy.txt*.

##Output Dataset File:

The output data *Tidy.txt* is a a space-delimited value file with the characteristics below:

- The header subject line contains the names of each respective variable. 
- It includes the mean and standard deviation values of the sample data from the input files.
- The header is re-arranged in an understandable manner. 
