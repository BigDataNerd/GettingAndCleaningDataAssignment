##GettingAndCleaningDataAssignment
================================

#Overview
The file run_analysis.R contains a function 'createTidyData(filename)' that accepts a zip file
name, extracts the contents of the zip file, and processes the contents as described below to
create a "tidy data" data set (named 'tidydata.txt') summarizing the results.

#Processing Steps
The basic processing steps are as follows:
- Extract the zip file contents
- Read 'features.txt' and find the indices of all features ending in 'mean()' or 'std()'
- Read the data files 'train/X_train.txt' and 'test/X_test.txt', retaining only the data corresponding to the column indices found in the previous step.  The data from both files are concatenated into a single data frame.
- Read the data files 'train/subject_train.txt' and 'test/subject_test.txt' containing the subject IDs.  The data from both files are concatenated into a single data frame.
- Read the data files 'train/Y_train.txt' and 'test/Y_test.txt' containing activity codes.  The data from both files are concatenated into a single data frame. 
- Merge the subject, activity, and measurement data into a single data frame.
- Loop over all combinations of unique subject and activity, extract the subset of data for each combination, and calculate the mean for each column of measurement data, aggregating all partial results into a data frame.
- Export the resulting data frame as 'tidydata.txt', then delete all files and directories extracted from the original zip file.

#Assumptions
* The zip file contents, when extracted, contain the following files:
 * features.txt: List of all features
 * activity_labels.txt: Links the class labels with their activity name
 * train/subject_train.txt: IDs for subjects in training set
 * test/subject_test.txt: IDs for subjects in test set
 * train/X_train.txt: Training set of measurement data
 * test/X_test.txt: Test set of measurement data
 * train/Y_train.txt: Training labels
 * test/Y_test.txt: Test labels