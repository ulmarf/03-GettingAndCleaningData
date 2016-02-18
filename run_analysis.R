# R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.

dir_name <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/"

x_train <- read.table(paste(dir_name, "train/X_train.txt", sep = ""))
y_train <- read.table(paste(dir_name, "train/y_train.txt", sep = ""))
subject_train <- read.table(paste(dir_name, "train/subject_train.txt", sep = ""))

x_test <- read.table(paste(dir_name, "test/X_test.txt", sep = ""))
y_test <- read.table(paste(dir_name, "test/y_test.txt", sep = ""))
subject_test <- read.table(paste(dir_name, "test/subject_test.txt", sep = ""))

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

dim(x_data)
# [1] 10299   561
dim(y_data)
# [1] 10299   1
dim(subject_data)
# [1] 10299   1
nrow(unique(y_data))
# [1] 6
nrow(unique(subject_data))
# [1] 30

# 2. Extracts only the measurements on the mean and standard deviation
# for each measurement. 

features <- read.table(paste(dir_name, "features.txt", sep = ""))

extracts <- grep("^.*-(mean|std)\\()", features[, 2])
extracts <- sort(c(grep(glob2rx("*-mean()*"), features[, 2]),
                   grep(glob2rx("*-std()*"), features[, 2])))
x_data <- x_data[, extracts]
dim(x_data)
# [1] 10299    66

# 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table(paste(dir_name, "activity_labels.txt", sep = ""))

activity_labels[, 2] <- tolower(activity_labels[, 2])
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# 4. Appropriately labels the data set with descriptive variable names.

x_data_names <- features[extracts, 2]
x_data_names <- gsub("-", "_", x_data_names)
x_data_names <- gsub("\\()", "", x_data_names)

names(x_data) <- x_data_names
names(y_data) <- c("activity")
names(subject_data) <- c("subject")

data <- cbind(y_data, subject_data, x_data)
dim(data)
# [1] 10299    68

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

library(sqldf)
sql <- paste("SELECT activity, subject ",
             "FROM data GROUP BY activity, subject")
data_tidy <- sqldf(sql, drv = "SQLite")

for(i in 3:ncol(data)) {
    cat("iterate =", i, "\n")
    sql <- paste("SELECT AVG(",
                 names(data)[i], ") AS ", names(data)[i],
                 "FROM data GROUP BY activity, subject")
    data_tmp <- sqldf(sql, drv = "SQLite")
    data_tidy <- cbind(data_tidy, data_tmp)
}

dim(data_tidy)
# [1] 180  68

write.table(data_tidy, "data_tidy.txt")
