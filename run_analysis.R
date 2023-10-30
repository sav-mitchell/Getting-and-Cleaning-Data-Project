###install and load packages
install.packages("data.table")
install.packages("dplyr")

library("data.table")
library("dplyr")

###read metadata
featureNames <- read.table("features.txt", col.names = c("n", "functions"))
activityLabels <- read.table("activity_labels.txt", col.names = c("code", "activity"))

###read training data
subjectTrain <- read.table("subject_train.txt", col.names = "subject")
featuresTrain <- read.table("X_train.txt", col.names = featureNames$functions)
activityTrain <- read.table("y_train.txt", col.names = "code")

###reading test data
subjectTest <- read.table("subject_test.txt", col.names = "subject")
featuresTest <- read.table("X_test.txt", col.names = featureNames$functions)
activityTest <- read.table("y_test.txt", col.names = "code")

###merging the training and test data sets
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
feature <- rbind(featuresTrain, featuresTest)
runDataset <- cbind(activity, subject, feature)

###extracting measurements containing mean and the standard deviation
tidyData <- runDataset %>% select(subject, code, contains("mean"), contains("std"))

###renaming data variable in describing activities 
tidyData$code <- activity[tidyData$code, 2]
names(tidyData)[2] = "activity"
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))
names(tidyData)<-gsub("-mean()", "Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std()", "STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq()", "Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("angle", "Angle", names(tidyData))
names(tidyData)<-gsub("gravity", "Gravity", names(tidyData))

##making final tidy dataset
independentData <- tidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(independentData, "IndependentTidyData.txt", row.name=FALSE)
