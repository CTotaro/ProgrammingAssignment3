# Programming Assignment 3 Codebook
Course programming assignment for Coursera: Getting and Cleaning Data, Week 4

## Data Inspection Process
The first step in this script is to import all of the necessary data files.  I start with all files names either 'train' or 'test', since that is what
the prompt says will be the data to merge.  I also import the features.txt file, as that contains the feature names.

The next step is to look at the dimensions to see how each file will go together.  For example, both x_train and x_test files have 561 variables.
This matches up with the 561 observations in the features.txt file, so the features must describe the variables (columns) in the x data files.

Looking at the y_train and y_test files, I see that there are 7352 observations (rows) in the y_train file and 2947 observations in the y_test file.
These are the same number of observations in the x_train and x_test files respectively.  Based on the original README, I know that these files are 
the labels for each x observation, and that they correspond to an activity 1-6. The activity codebook can be found in activity_labels.txt

The last pieces are the 'subject' files.  After importing and looking at the dimensions, I see that subject_train has 7352 rows and subject_test has
2947 rows.  These once again match up with the x_train and the x_test data files perfectly.  The README tells us that these files identify the subject
who performed the activity.

To sum up succintly, let's look at the train data.  The subject_train tells which test subject performed each activity, as identified with a number 1-30.
The y_train tells which activity was being performed by that subject, as identified with a number 1-6.  The codebook for these activities is found
in activity_labels.txt.  And lastly, the measurments themselves are found in the x_train file, and there are 561 distinct variables being measured.
These 561 variables are identified using the features.txt file.
The same logic applies to the 'test' version of all those files.

## Walkthrough of data cleaning and tidying
Now that we know what each file means, we can work to paste it all back together into a single workable data set.

1. Apply the feature names from features.txt to each x data set using the colnames() function.
2. Use cbind() to create two data frames: 'train' and 'test'.  This is where the dimensions help
...The train data frame dimensions should be 7352 x 563. The test dimensions should be 2947 x 563.
3. Merge together the test and train data frames using the rbind() function.
4. Rename the first two columns "Subject" and "Activity" to be more descriptive of the contents.
5. Since the task is to summarize only data for which we take a mean or std, we need to filter out
the irrelevant columns.  Use grep on colnames(data) with the regex "mean[^F]|std" to find only 
columns that have either
	-the regex "mean" NOT followed by F (this eliminates the meanFreq measurements)
	OR
	-the regex "std"
grep() will return the indexes of each column with either mean or std.  Store this vector for later use.
*I am interpreting a strict definition of "mean" and "std", which is why I exclude the "meanFreq" values*
*Not sure if this is what most others do, but it did seem open for interpretation*
6. Create a new data frame, subsetted by only taking columns using the mean/std index vector from step 5.
7. Import the activity_labels file to examine which numeric value corresponds to which activity.
8. Using the coding in the activity_labels.txt file, recode the numeric 1-6 values in the column 'Activity'
to be descriptive of the activity that was being performed, using a series of nested ifelse statements.
9. Convert the new Activity column to class factor.
10. Load the dplyr package and convert your subset data frame to be a tbl, usable in the dplyr environment.
11. Create the final data set which is a summarized version of each possible Subject.Activity combination.
 	This is done using the group_by() function to group the subset data frame by Subject and Activity.
	Then using the %>% syntax, the summarize_all() function is applied to compute the mean for each group.
	The summarize_all is a scoped variant of summarize() used to apply a desired operation on all groups.
12. Do a final check on the dimensions of this table.  It should have one row for each Subject/Activity
	combination. This yields N_subject * N_activities = N_rows, so 6 * 30 = 180 rows.
