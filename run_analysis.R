# The purpose of this project is to demonstrate ability to collect, work with, 
# and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
# List of required tasks to  be done:
# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names.
# 5 - From the data set in step 4, creates a second, independent tidy data set with 
#     the average of each variable for each activity and each subject.

# Load libraries
library(dplyr)
library(data.table)
library("stringr") 

# Prepare files system to work
if (!file.exists("./data")) {
  dir.create("./data")
}
wdd <- paste(getwd(), "data", sep = "/")
wds <- paste(wdd, "UCI HAR Dataset", sep = "/")
zfile <- paste(wdd, "UCIHARDataset.zip", sep = "/")

# Download and unzip required file
fileUrl <-
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(wds)) {
  if (!file.exists(zfile)) {
    download.file(fileUrl, destfile = zfile, method = "curl")
    unzip(zipfile = zfile, exdir = wdd)
    file.remove(zfile)
  }
}

# Read content data set
activity_labels <-
  read.table("./data/UCI HAR Dataset/activity_labels.txt",
             col.names = c("activityid", "activity"))
features <-
  read.table("./data/UCI HAR Dataset/features.txt",
             col.names = c("featureid", "features"))

subject_test <-
  read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subjectid")
x_test <-
  read.table(
    "./data/UCI HAR Dataset/test/X_test.txt",
    sep = "",
    col.names = features$features
  )
y_test <-
  read.table("./data/UCI HAR Dataset/test/y_test.txt",
             sep = "",
             col.names = "activityid")

subject_train <-
  read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subjectid")
x_train <-
  read.table(
    "./data/UCI HAR Dataset/train/X_train.txt",
    sep = "",
    col.names = features$features
  )
y_train <-
  read.table("./data/UCI HAR Dataset/train/y_train.txt",
             sep = "",
             col.names = "activityid")

# 1 - Combine and gather data set
train_text_x <- rbindlist(list(x_train, x_test))
train_text_y <- rbindlist(list(y_train, y_test))
train_text_s <- rbindlist((list(subject_train, subject_test)))
dt <- data.table(train_text_x, train_text_y, train_text_s)

# 2 - Extract mean and standard deviation
tidydt <-
  select(dt, activityid, subjectid, contains("mean"), contains("std"))

# 3 - Set descriptive names
tidydt$activityid <- activity_labels[tidydt$activityid, 2]

# 4 - Correct column labeling
s <-
  c(
    "activityid" = "Activity",
    "subjectid" = "Subject" ,
    "Acc" = "Accelerometer",
    "Gyro" = "Gyroscope",
    "BodyBody" = "Body",
    "Mag" = "Magnitude",
    "^t" = "Time",
    "^f" = "Frequency",
    "tBody" = "TimeBody",
    "-mean()" = "Mean",
    "-std()" = "STD",
    "-freq()" = "Frequency",
    "angle" = "Angle",
    "gravity" = "Gravity"
  )
names(tidydt) <- names(tidydt) %>% str_replace_all(s)

# 5 - Average of all values data set
tidydt_avg <- tidydt %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean))

# Save data set on file system
write.table(tidydt_avg, "./Analisis.txt", row.name=FALSE)
