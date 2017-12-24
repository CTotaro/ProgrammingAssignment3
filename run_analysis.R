# Course 3 Project
setwd("C:/Users/Christopher/R/Coursera/Course3/ProgrammingAssignment3/UCI_HAR_Dataset")

# Import data to inspect dimensions and see what matches up
train_x <- read.table("./train/X_train.txt", header=FALSE, sep= "")
train_y <- read.table("./train/y_train.txt", header=FALSE, sep= "")
train_subject <- read.table("./train/subject_train.txt", header=FALSE, sep="")

test_x <- read.table("./test/X_test.txt", header=FALSE, sep= "")
test_y <- read.table("./test/y_test.txt", header=FALSE, sep= "")
test_subject <- read.table("./test/subject_test.txt", header=FALSE, sep="")

features <- read.table("./features.txt", header=FALSE, sep="")
dim(features)   # The features.txt file has 561 rows, each corresponding to
                # a different measurement variable.  These 561 rows match
                # up with the 561 columns in the x data sets. They must be
                # used as variable names then.

# 1. Apply the feature names to the columns of the test and train data sets
colnames(train_x) <- features[,2]
colnames(test_x) <- features[,2]

# 2. Create train and test data frames that bind the subject, y, and x data
train <- cbind(train_subject, train_y, train_x)
test <- cbind(test_subject, test_y, test_x)

# 3. Merge the train and test data together into a single data frame
data <- rbind(train, test)

# 4. Rename the Subject and Activity columns, and reapply the features names
colnames(data) <- c("Subject", "Activity", as.vector(features[,2]))

# 5. Return an index of columns in x_data which contain either mean() or std()
meanstd <- grep("mean[^F]|std", colnames(data))

# 6. Generate a subset data frame of only mean and std values
data_sub <- data[,c(1,2,meanstd)]

# 7. Import the activity_labels .txt file
activity_labels <- read.table("./activity_labels.txt",header=FALSE, sep="")


# 8. Recode the numeric Activity values to be more descriptive.  The codebook
#    is in the activity_labels.txt file.
 data_sub$Activity <- ifelse(data_sub$Activity==1,"Walking",
                     ifelse(data_sub$Activity==2,"Walking Upstairs",
                     ifelse(data_sub$Activity==3,"Walking Downstairs",
                     ifelse(data_sub$Activity==4,"Sitting",
                     ifelse(data_sub$Activity==5,"Standing","Laying")))))

# 9. Change the Activity column to be a factor.
data_sub$Activity <- as.factor(data_sub$Activity)       

# 10. Load the dplyr package and convert the subset data frame to be a tbl.
library(dplyr)
tbl_df(data_sub)

# 11. Using the dplyr syntax, group the data_sub table by Subject and Activity,
#     then apply mean() to all variables (i.e. columns) by using summarize_all
final_table <- group_by(data_sub, Subject, Activity) %>% summarize_all(mean)

# 12. Check that the final table includes one row for each possible combination
#     of groups (N_subjects * N_activities = N_rows...30*6=180 rows)
dim(final_table)

# If you look at final_table, each column retains the same name as it had 
# in the data_sub table.  Now the values correspond to average values of that
# particular variable
View(final_table)

# Reset my working directory to be the folder which is version controlled
setwd("C:/Users/Christopher/R/Coursera/Course3/ProgrammingAssignment3")
write.table(final_table, file="tidy_data.txt", row.names=FALSE)
