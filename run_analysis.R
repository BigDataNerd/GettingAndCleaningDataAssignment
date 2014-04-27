## run_analysis.R
# 
#  This script will prepare a tidy data set by performing the following actions:
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

require(R.utils)

createTidyData <- function(zipfile) {
	if(!file.exists(zipfile)) {
		# error and exit
		
		return -1
	}
	
	unzip(zipfile)
	
	# move into newly created directory...
	allDirs = list.dirs(recursive=F)
	# find newest and setwd()...
	creationTimes = file.info(allDirs)$ctime
	newestDir = allDirs[[which.max(creationTimes)]]
	originalDir = setwd(newestDir)
	
	# features.txt contains the indices of all features in the data files.
	# read it and extract the col indices that correspond to mean and std measures...
	features <- read.table('features.txt', col.names=c('index','fName'))
	featureIndices <- sort(union(grep('mean\\(\\)', features$fName), grep('std\\(\\)', features$fName)))

	# Read in subject ID's for each case...
	subject <- read.table('train/subject_train.txt', col.names=c('subject'),colClasses='factor')
	subject <- rbind(subject, read.table('test/subject_test.txt', col.names=c('subject'), colClasses='factor'))
	
	# read data from train and test directories, combine...
	# use colClasses for efficiency
	X_data <- read.table('train/X_train.txt',colClasses='numeric')[,featureIndices]
	X_data <- rbind(X_data, read.table('test/X_test.txt',colClasses='numeric')[,featureIndices])
	#names(X_data) <- features$fName[featureIndices]
	names(X_data) <- gsub('-','.', gsub('[\\(\\)]','',features$fName[featureIndices]))
	
	# These are the codes for the activities being performed for each case...
	Y_data <- read.table('train/Y_train.txt', col.names=c('code'),colClasses='factor')
	Y_data <- rbind(Y_data, read.table('test/Y_test.txt',col.names=c('code'), colClasses='factor'))

	# activity_labels.txt contains the descriptions encoded in the Y files.
	# Read in activity IDs and labels, then add column using better factor names to Y_data
	activities <- read.table('activity_labels.txt', col.names=c('code','activity'))
	Y_data$activity <- activities$activity[Y_data$code]
	
	# cbind the three sets???  Show which activity was taking place for each subect/case?
	combinedData <- cbind(subject$subject, Y_data$activity, X_data)
	# cleans up last column name..
	names(combinedData) <- c(names(subject), c('activity'), names(X_data))

	# Subset the combined data by subject and activity, the calculate
	# the average of each variable for each activity and each subject. 
	tidydata<-data.frame()
	for(i in levels(combinedData$subject)) {
		dataSubset <- combinedData[combinedData$subject == i,]
		for(j in levels(dataSubset$activity)) {
			d2subset <- dataSubset[dataSubset$activity == j,]
			tidydata <- rbind(tidydata, calculateMeans(d2subset,2))
		}
	}
	
	# order the subjects numerically, not by factor values
	o <- order(as.integer(tidydata$subject))
	tidydata <- tidydata[o,]
	
	# Export the tidy data
	write.table(tidydata, file="../tidydata.txt", sep="\t", row.names=FALSE)
	
	# TODO - update README.md in the repo describing how the script works. 
	
	# finally change back to original directory and remove extracted dir...
	setwd(originalDir)
	removeDirectory(newestDir, recursive=T)
}

calculateMeans <- function(df, skipCols) {
	# for the given data frame, ignores the first 'skipCols' (indices) columns
	# and calculates mean of each of the remaining cols, returns data frame with
	# single row containing indices and all means.
	# Assumes that all values in index cols are identical
	result <- as.data.frame(lapply(df[,-c(1,skipCols)],mean))
	cbind(df[,c(1:skipCols)], result)
	return(cbind(df[1,c(1:skipCols)], result))
}