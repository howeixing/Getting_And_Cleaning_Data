## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for 
##    each activity and each subject.

#Assumption : The zip file is downloaded and extracted in working directory
#The Zip file link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#Loading Required libraries
library(data.table)
library(plyr)


#Load Supporting Metadata
featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)


#Format train data by splitting the data into subject, activity and features
#Loading train data and test data

subjectTrain  <- read.table("train/subject_train.txt", header = FALSE)
activityTrain <- read.table("train/y_train.txt", header = FALSE)
featuresTrain <- read.table("train/X_train.txt", header = FALSE)

subjectTest   <- read.table("test/subject_test.txt", header = FALSE)
activityTest  <- read.table("test/y_test.txt", header = FALSE)
featuresTest  <- read.table("test/X_test.txt", header = FALSE)


#Part 1 - To merge the training and the test sets to a new dataset
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#Naming the column names based on the features file with variable featureNames
colnames(features) <- t(featureNames[2])

#Adding activity and subject as a column to features
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)


#Part 2 - To extract the mean and standard deviation for each valid measurement
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

#Adding activity and subject columns
requiredColumns <- c(columnsWithMeanSTD, 562, 563)

#Pointing to the variable numbers in completeData
dim(completeData)
Extracted_Data <- completeData[,requiredColumns]

#Pointing to the variable numbers in Extracted_Data
dim(Extracted_Data)


#Part 3 - To use descriptive activity names for the activity names in the dataset

Extracted_Data$Activity <- as.character(Extracted_Data$Activity)

for (i in 1:6){
    Extracted_Data$Activity[Extracted_Data$Activity == i] <- as.character(activityLabels[i,2])
    }

#To set the activity variable as a factor
Extracted_Data$Activity <- as.factor(Extracted_Data$Activity)


#Part 4 - To label the dataset with descriptive variable names. 
#Pointing to variable names
names(Extracted_Data)

#Acc is replaced with Accelerometer
#Gyro is replaced with Gyroscope
#BodyBody is replaced with Body
#Mag is replaced with Magnitude
#Character 'f' is corrected to Frequency
#Character 't' is corrected to Time

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

#Pointing to new variable names
names(Extracted_Data)


#Part 5 - To create a second independent tidy dataset based on the dataset in step 4
#This new dataset is average of each variable for each respective activity and subject.
#The subject variable is setting as a factor

Extracted_Data$Subject <- as.factor(Extracted_Data$Subject)
Extracted_Data <- data.table(Extracted_Data)

#Create tidy_Data_average as a set with average for each activity and subject
tidy_Data_average <- aggregate(. ~Subject + Activity, Extracted_Data, mean)

#Order tidy_Data_average according to subject and activity
tidy_Data_average <- tidy_Data_average[order(tidy_Data_average$Subject,tidy_Data_average$Activity),]

#Write tidy_Data_average into a text file
write.table(tidy_Data_average, file = "Tidy.txt", row.names = FALSE)
