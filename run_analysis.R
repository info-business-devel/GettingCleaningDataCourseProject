### Coursera
### Data Science Specialization
### Getting and Cleaning Data
### Week 4
### Peer-graded Assignment

library(dplyr)

####################################################################
# 1.- Merges the training and the test sets to create one data set #
####################################################################

# TEST 
# Load "subjects":
test_subjects <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_subjects <- rename(test_subjects, subject = V1)

# Load "activities":
test_activities <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_activities <- rename(test_activities, activity = V1)

# Load "set":
test_set <- read.csv("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")

# Merge "test":
test_merge <- cbind(test_subjects, test_activities, test_set)

# TRAIN 
# Load "subjects":
train_subjects <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_subjects <- rename(train_subjects, subject = V1)

# Load "activities":
train_activities <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_activities <- rename(train_activities, activity = V1)

# Load "train":
train_set <- read.csv("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")

# Merge "set":
train_merge <- cbind(train_subjects, train_activities, train_set)

# SET: TEST + TRAIN
# Merge "test" + "train":
set_merge <- rbind(train_merge, test_merge)

#############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement #
#############################################################################################

# Load "features" and convert in character:
features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
features <- features %>% 
        select(-V1, V2) %>% 
        rename(feature = V2)
features$feature <- as.character(features$feature)

# Rename all columns with "feature" but "subject" and "activity":
colnames(set_merge)[3:ncol(set_merge)] <- features$feature

# Subset with "subject" and "activity" columns:
subset_subject_activity <- set_merge[, 1:2]

# Subset with "mean" columns:
columns_mean <- grep("mean",colnames(set_merge))
subset_mean <- set_merge[, columns_mean]

# Subset with "std" columns:
columns_std <- grep("std",colnames(set_merge))
subset_std <- set_merge[, columns_std]

# Subset with all subsets:
subset_set_merge <- cbind(subset_subject_activity, subset_mean, subset_std)

#############################################################################
# 3. Uses descriptive activity names to name the activities in the data set #
#############################################################################

# Use text "activities" instead of numbers:
activity_label <- function(x) {
        if (x == 1) {x = "walking"}
        else if (x == 2) {x = "walking_upstairs"}        
        else if (x == 3) {x = "walking_downstairs"}        
        else if (x == 4) {x = "sitting"}        
        else if (x == 5) {x = "standing"}        
        else if (x == 6) {x = "laying"}        
}
set_merge$activity <-sapply(set_merge$activity, activity_label)

#######################################################################
# 4. Appropriately labels the data set with descriptive variable name #
#######################################################################

# All cleaning and transformation have been done

# Save the tidy data set "set_merge" in a csv file:
write.table(set_merge, "set_merge.txt", row.name=FALSE)

#######################################################################
# 5. creates a second tidy data set with the average of each variable # 
# for each activity and each subject                                  #
#######################################################################

# Subset with "subject" and "activity" columns:
subset_subject_activity <- set_merge[, 1:2]

# Subset with "mean" columns:
columns_mean <- grep("mean",colnames(set_merge))
subset_mean <- set_merge[, columns_mean]

# New tidy data set "set_merge_2":
set_merge_2 <- cbind(subset_subject_activity, subset_mean)

# Group by "subject" and "activity":
set_merge_2 <- set_merge_2  %>% 
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

