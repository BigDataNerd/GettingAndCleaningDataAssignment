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
- Export the resulting data frame as 'tidy data.txt', then delete all files and directories extracted from the original zip file.

#Assumptions
* The zip file contents, when extracted, contain the following files:
 * features.txt
 * activity_labels.txt
 * train/subject_train.txt
 * test/subject_test.txt
 * train/X_train.txt
 * test/X_test.txt
 * train/Y_train.txt
 * test/Y_test.txt