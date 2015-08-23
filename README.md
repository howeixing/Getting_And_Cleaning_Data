Module: Getting and Cleaning Data

Subject: Course Assignment 

---------------------------------------------------------------

##Objective

Companies like *FitBit, Nike,* and *Jawbone Up* are racing to develop the most advanced algorithms to attract new users. The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained:  
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data is available at:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The core objective of this project is to clean and extract usable data from the above zip data file. A R script is created and named as  run_analysis.R can perform the following functionalities:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In this repository, you can find the following files:

- *run_analysis.R* : the R-code which is used for data analysis
- *Tidy.txt* : the clean data extracted from the original data using *run_analysis.R*
- *CodeBook.md* : the CodeBook is used for the reference of the variables in *Tidy.txt*
- *README.md* : the analysis of the code in *run_analysis.R*



## Getting Started

###Assumption made:

The R code in *run_analysis.R* is only can be used under the assumption that the zip file available at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> is downloaded and unzipped in the working directory.

###Libraries Used

The libraries used in this operation are `data.table` and `plyr`. We prefer `data.table` as it is efficient in handling large data as tables. `plyr` is used to aggregate variables to create the tidy data.

```{r}
library(data.table)
library(plyr)
```

###Load Supporting Metadata

The supporting metadata in this data are the feature names and the activitiy names. All are loaded into variables `featureNames` and `activityLabels`.
```{r}
featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)
```

###Format training and test data sets

Both training and test data sets are categorized into subject, activity and features, which are present in three different files. 

###Load training data
```{r}
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("train/y_train.txt", header = FALSE)
featuresTrain <- read.table("train/X_train.txt", header = FALSE)
```

###Load test data
```{r}
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("test/y_test.txt", header = FALSE)
featuresTest <- read.table("test/X_test.txt", header = FALSE)
```


##Part 1 - Merge the training and the test sets to create one data set
In the following steps. the respective data in training and test data sets are merged together in corresponding to subject, activity and features. The results are stored in `subject`, `activity` and `features`.
```{r}
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)
```
###Naming the columns
The columns of the features data set can be named from the metadata in `featureNames`

```{r}
colnames(features) <- t(featureNames[2])
```

###Combine the data
The data in `features`,`activity` and `subject` are merged and the complete data is stored as `completeData`.

```{r}
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)
```


##Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement

Extract the column indices that have either mean or standard deviation of each valid measurament.
```{r}
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
```
Adding the activity and subject columns to the list and pointing to the dimension of `completeData` 
```{r}
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
```
`Extracted_Data` is created with the selected columns in `requiredColumns`. And again, it has been pointing back at the dimension of `requiredColumns`. 
```{r}
Extracted_Data <- completeData[,requiredColumns]
dim(Extracted_Data)
```


##Part 3 - Uses descriptive activity names to name the activities in the data set
The `activity` field in `Extracted_Data` has been converted from numeric type to character type in order to acceept activity names in string value. The activity names are loaded from metadata `activityLabels`.
```{r}
Extracted_Data$Activity <- as.character(Extracted_Data$Activity)
for (i in 1:6){
Extracted_Data$Activity[Extracted_Data$Activity == i] <- as.character(activityLabels[i,2])
}
```
We need to factor the `activity` variable, once the activity names are updated.
```{r}
Extracted_Data$Activity <- as.factor(Extracted_Data$Activity)
```
##Part 4 - Appropriately labels the data set with descriptive variable names
Referring back to the variable names in `Extracted_Data` 
```{r}
names(Extracted_Data)
```
To label the column with the apprioprate description with the following column subjects:

- `Acc` is replaced with Accelerometer
- `Gyro` is replaced with Gyroscope
- `BodyBody` is replaced with Body
- `Mag` is replaced with Magnitude
- Character `f` is substituted with Frequency
- Character `t` is substituted with Time

```{r}
names(Extracted_Data)<-gsub("Acc", "Accelerometer", names(Extracted_Data))
names(Extracted_Data)<-gsub("Gyro", "Gyroscope", names(Extracted_Data))
names(Extracted_Data)<-gsub("BodyBody", "Body", names(Extracted_Data))
names(Extracted_Data)<-gsub("Mag", "Magnitude", names(Extracted_Data))
names(Extracted_Data)<-gsub("^t", "Time", names(Extracted_Data))
names(Extracted_Data)<-gsub("^f", "Frequency", names(Extracted_Data))
names(Extracted_Data)<-gsub("tBody", "TimeBody", names(Extracted_Data))
names(Extracted_Data)<-gsub("-mean()", "Mean", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("-std()", "STD", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("-freq()", "Frequency", names(Extracted_Data), ignore.case = TRUE)
names(Extracted_Data)<-gsub("angle", "Angle", names(Extracted_Data))
names(Extracted_Data)<-gsub("gravity", "Gravity", names(Extracted_Data))
```
Here are the variable names after the correction on the label description:
```{r}
names(Extracted_Data)
```

##Part 5 - From the dataset in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

`Subject`is setting as a factor variable as below:
```{r}
Extracted_Data$Subject <- as.factor(Extracted_Data$Subject)
Extracted_Data <- data.table(Extracted_Data)
```
So a new dataframe `tidy_Data_average` is created as a data set with average of each activity and subject. 

It will be followed by re-arranging the entries in `tidy_Data_average`:

```{r}
tidy_Data_average <- aggregate(. ~Subject + Activity, Extracted_Data, mean)
tidy_Data_average <- tidy_Data_average[order(tidy_Data_average$Subject,tidy_Data_average$Activity),]
```
The processed data is loaded into the final output data file *Tidy.txt*.

```{r}
write.table(tidy_Data_average, file = "Tidy.txt", row.names = FALSE)
```
