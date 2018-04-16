
# Explanation of the code

There are several files with information about a set of data. This data has been divided into two pieces:

1.- Test.
2.- Train.

The objective of this code is:

1.- Gather both pieces of information.
2.- Clean and transform the data set so that you can work on it.
3.- The code analysis should be self-explanatory.

Loading libraries
```R 
library(dplyr)
library(forcats)
```

# Test
Load "subjects":
```R 
test_subjects <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_subjects <- rename(test_subjects, subject = V1)
```

Load "activities":
```R
test_activities <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_activities <- rename(test_activities, activity = V1)
```

Load "set":
```R 
test_set <- read.csv("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
```

Merge "test":
```R 
test_merge <- cbind(test_subjects, test_activities, test_set)
```

# Train
Load "subjects":
```R
train_subjects <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_subjects <- rename(train_subjects, subject = V1)
```

Load "activities":
```R 
train_activities <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_activities <- rename(train_activities, activity = V1)
```

Load "set":
```R 
train_set <- read.csv("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
```

Merge "train":
```R 
train_merge <- cbind(train_subjects, train_activities, train_set)
```

# Set: Test + Train
Merge "test" + "train":
```R 
set_merge <- rbind(train_merge, test_merge)
```

Load "features" and convert it in character to be able to use them as a columns names:
```R 
features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
features <- features %>% 
        select(-V1, V2) %>% 
        rename(feature = V2)
features$feature <- as.character(features$feature)
```

Rename all columns with "feature" but "subject" and "activity":
```R
colnames(set_merge)[3:ncol(set_merge)] <- features$feature
```

# Creating a subset with mean and standard deviation for each measurement
Subset with "subject" and "activity" columns:
```R 
subset_subject_activity <- set_merge[, 1:2]
```

Subset with "mean" columns:
```R 
columns_mean <- grep("mean",colnames(set_merge))
subset_mean <- set_merge[, columns_mean]
```

Subset with "std" columns:
```R 
columns_std <- grep("std",colnames(set_merge))
subset_std <- set_merge[, columns_std]
```

Subset with all subsets:
```R 
subset_set_merge <- cbind(subset_subject_activity, subset_mean, subset_std)
```

Use label activities (walking, ...) instead of numbers:
```R 
activity_label <- function(x) {
        if (x == 1) {x = "walking"}
        else if (x == 2) {x = "walking_upstairs"}        
        else if (x == 3) {x = "walking_downstairs"}        
        else if (x == 4) {x = "sitting"}        
        else if (x == 5) {x = "standing"}        
        else if (x == 6) {x = "laying"}        
}
set_merge$activity <-sapply(set_merge$activity, activity_label)
```

# All cleaning and transformation have been done
Save the tidy data set "set_merge" in a csv file:
```R 
write.csv(set_merge, "set_merge.csv")
```

# A new tidy data set grouped by "subject" and "activity"
```R 
Subset with "subject" and "activity" columns:
subset_subject_activity <- set_merge[, 1:2]
```

Subset with "mean" columns:
```R
columns_mean <- grep("mean",colnames(set_merge))
subset_mean <- set_merge[, columns_mean]
```

New tidy data set "set_merge_2":
```R
set_merge_2 <- cbind(subset_subject_activity, subset_mean)
```

Group by "subject" and "activity":
```R
set_merge_2 <- set_merge_2  %>% 
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
```
