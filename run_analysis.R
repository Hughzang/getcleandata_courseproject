library(dplyr)
library(plyr)



# 1. Merge the training and test sets to create one data set

# Import test & train data
x_testdata <- read.table("test/X_test.txt")
y_testdata <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
x_traindata <- read.table("train/X_train.txt")
y_traindata <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# Combine test & train dataset to create a new dataset
x_data       <- rbind(x_traindata, x_testdata)
y_data       <- rbind(y_traindata, y_testdata)
subject_data <- rbind(subject_train, subject_test)



# 2. Extract only the measurements on the mean and standard deviation for each measurement

# Import features
features <- read.table("features.txt")

# Gain mean() or std()
features_mead_std <- grep("-(mean|std)\\(\\)", features[, 2])

# Select Attributes
x_data <- x_data[, features_mead_std]

# Change the column names
names(x_data) <- features[features_mead_std, 2]



# 3. Use descriptive activity names to name the activities in the data set

# Import activity labels
activities <- read.table("activity_labels.txt")

# Update the value with correct activity name
y_data[, 1] <- activities[y_data[, 1], 2]

# Change the column names
names(y_data) <- "activity"



# 4. Appropriately label the data set with descriptive variable names

# Change the column names
names(subject_data) <- "subject"

# Bind all the data in one new dataset
z <- cbind(x_data, y_data, subject_data)



# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Adjust
resultdata <- ddply(z, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(resultdata, "averages_data.txt", row.name=FALSE)
