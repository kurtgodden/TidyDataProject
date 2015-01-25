########################################################  
####################  Instructions  ####################  
########################################################  

# 1.  Merges the training and the test sets to create one data set.
# 2.  Extracts only the measurements on the mean and standard deviation 
#     for each measurement. 
# 3.  Uses descriptive activity names to name the activities in the data set
# 4.  Appropriately labels the data set with descriptive variable names. 
# 5.  From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.

########################################################  
#############  1. Download Raw Data from Web  ##########  
########################################################  

> getwd()
#[1] "/Users/Kurt/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData"
if(!file.exists("./CourseProject"))(dir.create("./CourseProject"))
RawDataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(RawDataURL, destfile="./CourseProject/RawDataSet.zip", method="curl")
dataDownloadDate <- date()
dataDownloadDate
#[1] "Tue Jan 13 20:09:51 2015" #Return val of previous line
unzip("./CourseProject/RawDataSet.zip", exdir="./CourseProject/")

############################################################
#############  2. Read raw data into data frames  ##########  
############################################################  

#  First, get pointers to each file
trainingSetPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/train/X_train.txt"
trainingLabelsPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/train/y_train.txt"
trainingSubjectsPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/train/subject_train.txt"

testSetPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/test/X_test.txt"
testLabelsPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/test/y_test.txt"
testSubjectsPath <- 
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/test/subject_test.txt"

activityLabelsPath <-
    "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/activity_labels.txt"

featuresPath <- "~/Documents/Kurt's Classes/Coursera/Data Science/R Working Directory/CleaningData/CourseProject/UCI HAR Dataset/features.txt"

# Now, read each file into a data frame
activityLabelsMap <- read.table(activityLabelsPath) #get activity labels
#Use activityLabelsMap to map the numeric labels in trainingRawLabels and 
#testRawLabels below into the descriptive text to be added to table

trainingRawData <- read.table(trainingSetPath)      
#7352 rows, 561 cols, no headers
trainingRawLabels <- read.table(trainingLabelsPath) 
#7352 digits, no headers, representing the activities 
trainingRawSubjects <- read.table(trainingSubjectsPath) 
#7352 digits, representing test subjects

testRawData <- read.table(testSetPath)              
#2947 rows, 561 cols, no headers
testRawLabels <- read.table(testLabelsPath)         
#2947 digits, no headers. These represent the activities
testRawSubjects <- read.table(testSubjectsPath)
#2947 digits, no headers, representing test subjects

allFeatures <- read.table(featuresPath)$V2 #get vector of all var names
# 561 names of features in the training and test datasets

########################################################  
#############  3. Get Data Vars of Interest  ###########  
########################################################  

#Get only mean and standard deviation variables
#by finding only the ones whose text names
#contain either 'mean' or 'std'.  
#Then add these as headers to the training and test sets
#so we can merge the 2 datasets 

meansAndStds <- grep("mean|std", allFeatures)  #get indices of means/stds
meansStdsColNames <- grep("mean|std", allFeatures, value=TRUE) #get their names

#Now make them more readable
meansStdsColNamesReadable <- gsub("-mean\\(\\)", "Mean", 
                                  meansStdsColNames)
meansStdsColNamesReadable <- gsub("-std\\(\\)", "StDev", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- gsub("-meanFreq\\(\\)", "MeanFreq", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- gsub("Acc", "Acceleration", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- gsub("Gyro", "Gyroscope", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- gsub("Mag", "Magnitude", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- gsub("-", "", 
                                  meansStdsColNamesReadable)
meansStdsColNamesReadable <- sub("^t", "time", 
                                 meansStdsColNamesReadable)
meansStdsColNamesReadable <- sub("^f", "frequency", 
                                 meansStdsColNamesReadable)

#This returns 79 column indices
#Now get subsets of the 2 datasets of only those vars
trainingDataMeansStds <- trainingRawData[, meansAndStds]
testDataMeansStds <- testRawData[, meansAndStds]
#now add headers to each of these subsets
colnames(trainingDataMeansStds) <- meansStdsColNamesReadable
# To see results: head(trainingDataMeansStds)
colnames(testDataMeansStds) <- meansStdsColNamesReadable
#To see results: head(testDataMeansStds)

########################################################  
##### 4. Merge datasets & add Subjects & Activities ####  
########################################################  

testActivities <- sapply(testRawLabels$V1, 
                         function (act) 
                             {activityLabelsMap[activityLabelsMap$V1==act, 2]})

trainingActivities <- sapply(trainingRawLabels$V1, 
                             function (act) 
                                 {activityLabelsMap[activityLabelsMap$V1==act, 2]})
# Now add testActivities and trainingActivities as new columns to the test/training sets
#then similarly add the Subjects column to each dataset and THEN I can do the merge

trainingDataWithActivities <- cbind(Activity=trainingActivities, 
                                    trainingDataMeansStds)
testDataWithActivities <- cbind(Activity=testActivities, 
                                testDataMeansStds)
trainingDataAll <- cbind(Subject=trainingRawSubjects,
                         trainingDataWithActivities)
testDataAll <- cbind(Subject=testRawSubjects,
                     testDataWithActivities)
#Mysteriously 'Subject' not added in preceding as Var label, yet 'Activity' is!!
#Here is the fix for this weirdness:
names(trainingDataAll)[1] <- "Subject"
names(testDataAll)[1] <- "Subject"

#Now merge these 2 datasets

mergedDataAll <- merge(trainingDataAll, testDataAll, all = TRUE)

########################################################  
################ 5. Create Tidy Dataset ################  
########################################################  

#The tidy data is created from an intermediate dataframe
#The format for this intermediate DF is:
#     SUBJECT                   VARIABLE      LAYING      SITTING    STANDING     WALKING WALKING_DOWNSTAIRS
# 1         1  timeBodyAccelerationMeanX  0.22159824  0.261237565  0.27891763  0.27733076        0.289188320
#etc.
#The final tidy data has slightly different column names to indicate
#that the values represent the means of the activities for some subject
#and variable.

#Define fn to compute the means of each activity for every combination of 
#subject and variable
computeVarMeans <- function (df) {
    #df is the merged data frame of all test and training data
    #which now also contains variables for subject and activity
    
    #First, create an 'empty' dataframe with one row of NA values to which
    #we'll incrementally rbind new rows of data for each activity
    intermediateDF <- data.frame(LAYING=NA, SITTING=NA, 
                                 STANDING=NA, WALKING=NA, 
                                 WALKING_DOWNSTAIRS=NA, WALKING_UPSTAIRS=NA)
    #We'll also incrementally build vectors for SUBJECT and VARIABLE
    #that we'll cbind to intermediateDF before returning.
    subjectVector <- c(NA)
    varVector <- c(NA)
    # I will delete this row of NA values before returning the final result
    
    #Now loop thru Subject, Activities and compute means for each combo
    for (sbj in unique(df$Subject)) {
        #get dataframe of all rows for each single sbj
        tmpDF <- df[df$Subject==sbj,] 
        for (variable in 3:ncol(df)) { #skip Subject and Activity columns
            #compute activity means of each variable 
            #for each activity of this sbj 
            #This is the workhorse of this function
            tmpArray<- tapply(tmpDF[[variable]], 
                              tmpDF$Activity, 
                              mean, na.rm=TRUE)
            tmpList <- as.list(tmpArray) #for as.data.frame below 
##########################################################################
#  I found that every row of data is same for the two variables:
#  mergedDataAll$timeBodyAccelerationMagnitudeMean 
#  mergedDataAll$timeGravityAccelerationMagnitudeMean
#  Even though those 2 variables have identical data, indicating that one of 
#  them is likely wrong (copy/paste problem in original data?), 
#  I decided to retain both variables since it's not possible to determine 
#  which is wrong.
#  Because my loop that calcs the means will give same values for these 2 vars,
#  the 'merge' shown here won't work, which is how I discovered the bad
#  data. To avoid this I'm replacing the 'merge' with 'rbind' below,
#  which I think is much more efficient anyway.
#             intermediateDF <- merge(intermediateDF, 
#                                     as.data.frame(tmpList),
#                                     all=TRUE, sort=FALSE)
##########################################################################
            #Add these activity means as new row to the intermediate dataframe
            intermediateDF <- rbind(intermediateDF, as.data.frame(tmpList))
            #Similarly, add sbj and variable to their vectors
            subjectVector <- c(subjectVector, sbj)
            varVector <- c(varVector, names(tmpDF)[variable])
        }
    }
    #Add the SUBJECT and VARIABLE columns to the near-final data frame
    intermediateDF <-cbind (VARIABLE=varVector, intermediateDF)
    intermediateDF <-cbind (SUBJECT=subjectVector, intermediateDF)

    #Delete the NA row, rename rows, then return
    goodRows <- complete.cases(intermediateDF)  #This only deletes row 1
    intermediateDF <- intermediateDF[goodRows,] #but safely and w/o hardcoding it
    
    # To avoid the row names starting at 2, renumber from 1
    rownames(intermediateDF) <- 1:nrow(intermediateDF)
    # The last thing is to rename the column names because the current 
    # col names are LAYING, SITTING, STANDING, etc. for the activity names.
    # But that is misleading for the tidy data set because the values in
    # tidy data are the means of those activities, hence the new names.
    colnames(intermediateDF) <- c("Subject", "Variable", "LayingMean", 
                                  "SittingMean", "StandingMean", "WalkingMean",
                                  "WalkingDownstairsMean", "WalkingUpstairsMean")
    intermediateDF #this is the final return value
}

#invoke above function to operate on the merged training and test dataset
tidyData <- computeVarMeans(mergedDataAll)
#
# Because there are 79 variables and 30 subjects, we expect to see
# 79 x 30 = 2370 rows of data, each row showing the mean for each of the 6
# activities, in addition to the identifier for the subject and the name of 
# the data variable, i.e. 8 columns total.
# The following shows that I got exactly the expected dimensions:
# > dim(tidyData)
# [1] 2370    8

#Now write the resulting tidy data into a file
write.table(tidyData, file="./CourseProject/MyTidyData.txt", row.names=FALSE)

#I used row.names=FALSE because that was in the assignment requirements.
#But I notice that doing so causes the headers to be stored in the dataset
#as if they were another row of data, not as headers.  

#  MyTidyData <- read.table("./CourseProject/MyTidyData.txt")
#  
# head(MyTidyData)
# V1                         V2               V3                   V4                  V5
# 1 Subject                   Variable       LayingMean          SittingMean        StandingMean
# 2       1  timeBodyAccelerationMeanX    0.22159824394    0.261237565425532   0.278917629056604
# 3       1  timeBodyAccelerationMeanY -0.0405139534294 -0.00130828765170213 -0.0161375901037736
# 4       1  timeBodyAccelerationMeanZ   -0.11320355358   -0.104544182255319  -0.110601817735849
# 5       1 timeBodyAccelerationStDevX    -0.9280564692   -0.977229008297872  -0.995759901509434
# 6       1 timeBodyAccelerationStDevY   -0.83682740562   -0.922618641914894  -0.973190056415094
# V6                    V7                   V8
# 1         WalkingMean WalkingDownstairsMean  WalkingUpstairsMean
# 2   0.277330758736842     0.289188320408163    0.255461689622641
# 3 -0.0173838185273684  -0.00991850461020408  -0.0239531492643396
# 4  -0.111148103547368    -0.107566190908163  -0.0973020020943396
# 5  -0.283740258842105    0.0300353383483878    -0.35470802509434
# 6   0.114461336747368   -0.0319359434489796 -0.00232026501698113
#
# > dim(MyTidyData)
# [1] 2371    8
#  Compare that with:
# > dim(tidyData)
# [1] 2370    8


