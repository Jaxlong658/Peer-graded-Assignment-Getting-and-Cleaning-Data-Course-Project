##load package needed
library(reshape2)

##load downloaded datasets needed for assignment
x_test <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/train/subject_train.txt")

activity_labels <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/activity_labels.txt")
features <- read.table("~/Documents/R stuff/week 4, course 3/UCI HAR Dataset/features.txt")

# change column 2 into character
activity_labels[,2] <- as.character(activity_labels[,2])
features[,2] <- as.character(features[,2])

# Extract the data for mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# concatenate the datasets together
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)

# merge the big datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- as.character(c("subject", "activity", features[,2]))

# make activities and subjects into factors
allData$activity <- factor(allData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$subject <- as.factor(allData$subject)

## get the average of each variable for each activity and each subject.
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

## write dataset to a saved file
write.table(allData.mean, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)
