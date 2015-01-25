
This document describes my R script that converts the raw UCI HAR data into a 'tidy' dataset.

The script is organized by 5 logical sections which are clearly delineated by comments, 
e.g. the first such code block is indicated by:
########################################################  
#############  1. Download Raw Data from Web  ##########  
########################################################  

What follows is now a description of each such code block.
## Block 1 

Block 1. The script begins by downloading the raw data 

The data was obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The date/time of the download was obtained by using date(), which returned a value of:
"Tue Jan 13 20:09:51 2015" which is documented in an R comment.

R function ‘unzip()’ is used to extract all the raw data files into 
directory 'UCI HAR Dataset' underneath my working directory.
################### Block 2 ############################

Block 2.  The next code block sets pointers to each relevant raw file which I determined 
by reading the data's README.txt file.  Here are the variables used and the raw files they point to:

trainingSetPath			X_train.txt
trainingLabelsPath 			y_train.txt
trainingSubjectsPath 		subject_train.txt
testSetPath 				X_test.txt
testLabelsPath 			y_test.txt
testSubjectsPath 			subject_test.txt
activityLabelsPath 			activity_labels.txt
featuresPath 				features.txt

These 8 path variables are then used as inputs to 8 calls to 'read.table()’
which reads each file into a raw data variable.  Here are the raw data variables 
and the raw data files whose contents are read into those variables:

trainingRawData 		X_train.txt
trainingRawLabels		y_train.txt
trainingRawSubjects 		subject_train.txt
testRawData			X_test.txt
testRawLabels 		y_test.txt
testRawSubjects 		subject_test.txt
activityLabelsMap		activity_labels.txt
allFeatures 			features.txt

Code comments include the dimensions of each resulting dataframe which I manually
obtained by calling 'dim()' on each raw data variable.
################### Block 3 ############################

Block 3.  The next code block subsets the raw training and test data, extracting only 
    the raw data variables of interest, and gives these subsets 
    more readable variable names.

First, 'grep' was used with a regular expression to obtain a vector of numeric 
indices into allFeatures where each index points to either a 'mean' or 'std' variable.
Similarly, 'grep' was again used to obtain a vector of the names of each of those variables.
These calls to 'grep' found 79 raw variables that contain either 'mean' or 'std'.
Those are the raw variables that the project instructions told us to extact

meansAndStds 		is the variable with the vector of indices
meansStdsColNames	is the variable with the vector of column (variable) names.

Here are the 79 raw variables extracted from the full set of 561:

> meansStdsColNames
 [1] "tBodyAcc-mean()-X"               "tBodyAcc-mean()-Y"               "tBodyAcc-mean()-Z"              
 [4] "tBodyAcc-std()-X"                "tBodyAcc-std()-Y"                "tBodyAcc-std()-Z"               
 [7] "tGravityAcc-mean()-X"            "tGravityAcc-mean()-Y"            "tGravityAcc-mean()-Z"           
[10] "tGravityAcc-std()-X"             "tGravityAcc-std()-Y"             "tGravityAcc-std()-Z"            
[13] "tBodyAccJerk-mean()-X"           "tBodyAccJerk-mean()-Y"           "tBodyAccJerk-mean()-Z"          
[16] "tBodyAccJerk-std()-X"            "tBodyAccJerk-std()-Y"            "tBodyAccJerk-std()-Z"           
[19] "tBodyGyro-mean()-X"              "tBodyGyro-mean()-Y"              "tBodyGyro-mean()-Z"             
[22] "tBodyGyro-std()-X"               "tBodyGyro-std()-Y"               "tBodyGyro-std()-Z"              
[25] "tBodyGyroJerk-mean()-X"          "tBodyGyroJerk-mean()-Y"          "tBodyGyroJerk-mean()-Z"         
[28] "tBodyGyroJerk-std()-X"           "tBodyGyroJerk-std()-Y"           "tBodyGyroJerk-std()-Z"          
[31] "tBodyAccMag-mean()"              "tBodyAccMag-std()"               "tGravityAccMag-mean()"          
[34] "tGravityAccMag-std()"            "tBodyAccJerkMag-mean()"          "tBodyAccJerkMag-std()"          
[37] "tBodyGyroMag-mean()"             "tBodyGyroMag-std()"              "tBodyGyroJerkMag-mean()"        
[40] "tBodyGyroJerkMag-std()"          "fBodyAcc-mean()-X"               "fBodyAcc-mean()-Y"              
[43] "fBodyAcc-mean()-Z"               "fBodyAcc-std()-X"                "fBodyAcc-std()-Y"               
[46] "fBodyAcc-std()-Z"                "fBodyAcc-meanFreq()-X"           "fBodyAcc-meanFreq()-Y"          
[49] "fBodyAcc-meanFreq()-Z"           "fBodyAccJerk-mean()-X"           "fBodyAccJerk-mean()-Y"          
[52] "fBodyAccJerk-mean()-Z"           "fBodyAccJerk-std()-X"            "fBodyAccJerk-std()-Y"           
[55] "fBodyAccJerk-std()-Z"            "fBodyAccJerk-meanFreq()-X"       "fBodyAccJerk-meanFreq()-Y"      
[58] "fBodyAccJerk-meanFreq()-Z"       "fBodyGyro-mean()-X"              "fBodyGyro-mean()-Y"             
[61] "fBodyGyro-mean()-Z"              "fBodyGyro-std()-X"               "fBodyGyro-std()-Y"              
[64] "fBodyGyro-std()-Z"               "fBodyGyro-meanFreq()-X"          "fBodyGyro-meanFreq()-Y"         
[67] "fBodyGyro-meanFreq()-Z"          "fBodyAccMag-mean()"              "fBodyAccMag-std()"              
[70] "fBodyAccMag-meanFreq()"          "fBodyBodyAccJerkMag-mean()"      "fBodyBodyAccJerkMag-std()"      
[73] "fBodyBodyAccJerkMag-meanFreq()"  "fBodyBodyGyroMag-mean()"         "fBodyBodyGyroMag-std()"         
[76] "fBodyBodyGyroMag-meanFreq()"     "fBodyBodyGyroJerkMag-mean()"     "fBodyBodyGyroJerkMag-std()"     
[79] "fBodyBodyGyroJerkMag-meanFreq()"

Next, a series of calls to 'gsub' are used to transform each raw column name 
from meansStdsColNames into a more descriptive column name that will be used 
in the final tidy data set.

These 'gsub' calls perform the following:
  
  a. Convert all occurrences of '-mean()' to 'Mean'
  
  b. Convert all occurrences of '-std()' to 'StdDev'
  
  c. Convert all occurrences of '-meanFreq()' to 'MeanFreq'
  
  d. Convert all occurrences of 'Acc' to 'Acceleration'
  
  e. Convert all occurrences of 'Gyro' to 'Gyroscope'
  
  f. Convert all occurrences of 'Mag' to 'Magnitude'
  
  g. Delete all remaining occurrences of '-'
  
  h. Convert all prefix occurrences of 't' to 'time'
  
  i. Convert all prefix occurrences of 'f' to 'frequency'

One example of a raw column name transformation would be:
tBodyAcc-mean()-X
	->	timeBodyAccelerationMeanX

Granted, these new column names are still technical, but avoid potential
confusion over interpretations of abbreviations such as 'Acc’, 'Mag’, or
even worse: ‘std’.  :-)

I chose not to convert 'meanFreq' to 'MeanFrequency' simply because it 
is awkward for column names to have 2 occurrences of the word 'Frequency', 
e.g. fBodyAccJerk-meanFreq()-X 
  -> frequencyBodyAccelerationJerkMeanFrequencyX


The resulting vector of more readable column names are stored in variable:
meansStdsColNamesReadable 
Here is its value with all 79 transformed variable names:
> meansStdsColNamesReadable
 [1] "timeBodyAccelerationMeanX"                          "timeBodyAccelerationMeanY"                         
 [3] "timeBodyAccelerationMeanZ"                          "timeBodyAccelerationStDevX"                        
 [5] "timeBodyAccelerationStDevY"                         "timeBodyAccelerationStDevZ"                        
 [7] "timeGravityAccelerationMeanX"                       "timeGravityAccelerationMeanY"                      
 [9] "timeGravityAccelerationMeanZ"                       "timeGravityAccelerationStDevX"                     
[11] "timeGravityAccelerationStDevY"                      "timeGravityAccelerationStDevZ"                     
[13] "timeBodyAccelerationJerkMeanX"                      "timeBodyAccelerationJerkMeanY"                     
[15] "timeBodyAccelerationJerkMeanZ"                      "timeBodyAccelerationJerkStDevX"                    
[17] "timeBodyAccelerationJerkStDevY"                     "timeBodyAccelerationJerkStDevZ"                    
[19] "timeBodyGyroscopeMeanX"                             "timeBodyGyroscopeMeanY"                            
[21] "timeBodyGyroscopeMeanZ"                             "timeBodyGyroscopeStDevX"                           
[23] "timeBodyGyroscopeStDevY"                            "timeBodyGyroscopeStDevZ"                           
[25] "timeBodyGyroscopeJerkMeanX"                         "timeBodyGyroscopeJerkMeanY"                        
[27] "timeBodyGyroscopeJerkMeanZ"                         "timeBodyGyroscopeJerkStDevX"                       
[29] "timeBodyGyroscopeJerkStDevY"                        "timeBodyGyroscopeJerkStDevZ"                       
[31] "timeBodyAccelerationMagnitudeMean"                  "timeBodyAccelerationMagnitudeStDev"                
[33] "timeGravityAccelerationMagnitudeMean"               "timeGravityAccelerationMagnitudeStDev"             
[35] "timeBodyAccelerationJerkMagnitudeMean"              "timeBodyAccelerationJerkMagnitudeStDev"            
[37] "timeBodyGyroscopeMagnitudeMean"                     "timeBodyGyroscopeMagnitudeStDev"                   
[39] "timeBodyGyroscopeJerkMagnitudeMean"                 "timeBodyGyroscopeJerkMagnitudeStDev"               
[41] "frequencyBodyAccelerationMeanX"                     "frequencyBodyAccelerationMeanY"                    
[43] "frequencyBodyAccelerationMeanZ"                     "frequencyBodyAccelerationStDevX"                   
[45] "frequencyBodyAccelerationStDevY"                    "frequencyBodyAccelerationStDevZ"                   
[47] "frequencyBodyAccelerationMeanFreqX"                 "frequencyBodyAccelerationMeanFreqY"                
[49] "frequencyBodyAccelerationMeanFreqZ"                 "frequencyBodyAccelerationJerkMeanX"                
[51] "frequencyBodyAccelerationJerkMeanY"                 "frequencyBodyAccelerationJerkMeanZ"                
[53] "frequencyBodyAccelerationJerkStDevX"                "frequencyBodyAccelerationJerkStDevY"               
[55] "frequencyBodyAccelerationJerkStDevZ"                "frequencyBodyAccelerationJerkMeanFreqX"            
[57] "frequencyBodyAccelerationJerkMeanFreqY"             "frequencyBodyAccelerationJerkMeanFreqZ"            
[59] "frequencyBodyGyroscopeMeanX"                        "frequencyBodyGyroscopeMeanY"                       
[61] "frequencyBodyGyroscopeMeanZ"                        "frequencyBodyGyroscopeStDevX"                      
[63] "frequencyBodyGyroscopeStDevY"                       "frequencyBodyGyroscopeStDevZ"                      
[65] "frequencyBodyGyroscopeMeanFreqX"                    "frequencyBodyGyroscopeMeanFreqY"                   
[67] "frequencyBodyGyroscopeMeanFreqZ"                    "frequencyBodyAccelerationMagnitudeMean"            
[69] "frequencyBodyAccelerationMagnitudeStDev"            "frequencyBodyAccelerationMagnitudeMeanFreq"        
[71] "frequencyBodyBodyAccelerationJerkMagnitudeMean"     "frequencyBodyBodyAccelerationJerkMagnitudeStDev"   
[73] "frequencyBodyBodyAccelerationJerkMagnitudeMeanFreq" "frequencyBodyBodyGyroscopeMagnitudeMean"           
[75] "frequencyBodyBodyGyroscopeMagnitudeStDev"           "frequencyBodyBodyGyroscopeMagnitudeMeanFreq"       
[77] "frequencyBodyBodyGyroscopeJerkMagnitudeMean"        "frequencyBodyBodyGyroscopeJerkMagnitudeStDev"      
[79] "frequencyBodyBodyGyroscopeJerkMagnitudeMeanFreq" 


We then subset the raw training and test sets, saving them into the variables
trainingDataMeansStds and testDataMeansStds, respectively.

Using the function 'colnames()’, we then provide the more readable column names
to each of those subsets.
################### Block 4 ############################

Block 4.  This code block merges the training and test datasets and also adds
    the two columns for (human) 'Subject' and 'Activity'.

First, 'sapply()’ is used on each of testRawLabels and trainingRawLabels 
with a function to map each numeric raw label to the corresponding
textual descriptive activity as found in activityLabelsMap, 
e.g. '4' is mapped to 'SITTING'.

testActivities is the resulting vector of the same length as the raw 
test data rows and contains the descriptive activity name for each row.

trainingActivities is the resulting vector for training data.

Those 2 vectors are then added to the raw datasets trainingDataMeansStds and
testDataMeansStds using 'cbind()’, saving the new dataframe into variables
trainingDataWithActivities and testDataWithActivities, respectively.

I then attempted to similarly use 'cbind' to add the vectors 
trainingRawSubjects and testRawSubjects onto trainingDataWithActivities and 
testDataWithActivities, but discovered (for reasons unknown to me) that
the column name 'Subject' was not correctly added in the resulting dataframes,
which are saved in the variables trainingDataAll and testDataAll.

I was able to add the column name correctly by simply calling:
	names(trainingDataAll)[1] <- "Subject"
	names(testDataAll)[1] <- "Subject"

Finally, I merged the training and test sets, now called 
trainingDataAll and testDataAll into a single dataset called 'mergedDataAll'
which contains 81 columns: Subject, Activity, and the 79 columns listed above 
of technical variables relating to means and standard deviations.

At this point, we have completed the first 4 instructions for the project:
1.  Merges the training and the test sets to create one data set. 
2.  Extracts only the measurements on the mean and standard deviation 
    for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
################### Block 5 ############################

Block 5.  The final code block does the heavy lifting of computing the mean of each
    combination of subject with technical variable, and then writes the resulting
    tidy dataset out to a file, completing all calculations.

The first step is to define a function 'computeVarMeans' which takes one argument, 
‘df’, that is the merged dataset stored in the dataframe ‘mergedDataAll’
at the end of code block 4.  This ‘computeVarMeans’ function operates as follows.

The general idea is to begin with an 'empty' dataframe called 'intermediateDF'
of NA values for each of the 6 activities, i.e. LAYING, SITTING, STANDING, 
WALKING, WALKING_DOWNSTAIRS and WALKING_UPSTAIRS.  We will compute the means 
for each of these activities and then use 'rbind()' to incrementally add 
each row as it is computed.  

Since there are 30 subjects and 79 technical variables, we expect to compute 
30 * 79 = 2370 rows of such data, one row for each combination of subject 
and technical variable.  These results are confirmed below.

In tandem with this incremental, row-by-row construction of intermediateDF,
we will similarly incrementally construct two vectors, one for the test subjects, 
called 'subjectVector' with values in the range 1:30 and one for the technical 
variable, called 'subjectVector', with names taken from one of the 79 columns
in dataframe mergedDataAll, e.g. timeBodyAccelerationMeanX.

Just as intermediateDF is initialized with one row of NA values, we initialize
subjectVector and varVector with one NA value.  This allows us to keep 
both vectors the same length as intermediateDF as all 3 are incrementally
constructed.

Each of these vectors should have the identical expected number of 2370 values 
as there are rows in the final intermediateDF.

To obtain each of the 2370 combinations of subjects and technical variables,
the function iterates through 2 nested loops, the outer loop using 'sbj' from
1:30 and the inner loop index 'variable' ranges 3:81 of mergedDataAll,
i.e. the 79 technical variable columns.  I coded this range as
3:ncol(df) simply to avoid hardcoding the ’81’.

The R function 'tapply' is used as the workhorse to compute the means.  It operates
on a subset of a temporary dataframe, 'tmpDF', that consists of all the rows 
from mergedDataAll that have the value of loop variable 'sbj' in the 'Subject' 
column.  Therefore, each tmpDF will contain all and only the data for one of 
the 30 test subjects. That same tmpDF will iterate 79 times in the inner loop, 
once for each technical variable.

Only the column vector for the inner loop index 'variable' is passed as data
for tapply to operate on.  In other words, each iteration of tapply will operate  
on all the numeric data that corresponds to the numeric column vector for 
one of the 79 technical variables like timeBodyAccelerationMeanX.

The second argument to tapply is the vector of the 'Activity' column of tmpDF, and the
third argument is the function we wish to apply, 'mean', also passing it the parameter
na.rm=TRUE just in case there are missing data values.

Because the 2nd argument is the list of Activity names, these 6 possible values are used
as factors, so that 'mean' will be computed 6 times, once for each of the collected
values of the first argument that all have the same Activity value.

tapply returns an array of the form:
            
            LAYING            SITTING           STANDING            WALKING WALKING_DOWNSTAIRS 
         
         0.2215982          0.2612376          0.2789176          0.2773308          0.2891883 
  
  	WALKING_UPSTAIRS 
         
         0.2554617
and saves it into the variable tmpArray, which is then converted to a list.

We convert it to a list because we want to then convert that to a dataframe
for use in the function 'rbind()' where we incrementally build, row by row,
the dataframe in intermediateDF that was described above.  

After ‘rbind()’ adds that new row of data to intermediateDF, we similarly add the 
subject 'sbj' and the technical variable name to their vectors subjectVector 
and varVector, respectively, keeping them the identical length  as the number
of rows in intermediateDF.  

The double looping in function computeVarMeans continues until we drop out of
the loops with the prefinal value of intermediateDF.  To finalize it, 
we have to add varVector and subjectVector as new columns using 'cbind()'.

From that resulting dataframe, we need to delete the first row of 
NA values from all columns, using ‘complete.cases() followed by a subset
operation, returning the nearly completed intermediateDF.  Since row 1
of NA values was deleted, the dataframe’s first row is now numbered ‘2’,
which is ugly.  Thus, I renumbered the rows using ‘rownames()’.

The final step in creating the tidy data is to rename the columns.  At 
the moment, the activities still use the activity names from the source
data, i.e. SITTING, STANDING, etc.  However, every value in those columns
is now actually a computed mean, so I changed those column names to
’SittingMean’ etc., which is more representative of the values below them.

The return value of the function is the now final ‘intermediateDF’.

The function described above is invoked by the command 
‘computeVarMeans(mergedDataAll)’ and its value is saved in the script 
variable 'tidyData'.

The final action of the script is to write out tidyData to an external file
called 'MyTidyData.txt' using 'write.table' with 'row.names=FALSE', per
the instructions for the project.  This external file was uploaded for the project,
also per instructions.

###############  Tidy Data Summary  ##################

ROWS:
Each row of tidyData represents one observation of mean activity values 
for one unique combination of ‘Subject’ with ‘Variable’.

COLUMNS:
This tidy dataset has 8 columns:
  Subject 
  Variable  
  LayingMean  
  SittingMean 
  StandingMean 
  WalkingMean 
  WalkingDownstairsMean  
  WalkingUpstairsMean

Here are the data types and descriptions of each column of data:

Subject:			integer, from 1:30 representing a person

Variable:			string, a more readable version of the 79 raw data
				variables of interest, viz. any variable representing
				either a mean or a standard deviation in the raw dataset.

LayingMean:			floating point, representing the mean value of a set
				numeric values for the activity of laying for the
				combination of Subject and Variable

SittingMean:			floating point, representing the mean value of a set
				numeric values for the activity of sitting for the
				combination of Subject and Variable

StandingMean:			floating point, representing the mean value of a set
				numeric values for the activity of standing for the
				combination of Subject and Variable

WalkingMean:			floating point, representing the mean value of a set
				numeric values for the activity of walking for the
				combination of Subject and Variable

WalkingDownstairsMean:	floating point, representing the mean value of a set
				numeric values for the activity of walking downstairs
	 			for the combination of Subject and Variable

WalkingUpstairsMean:		floating point, representing the mean value of a set
				numeric values for the activity of walking upstairs
	 			for the combination of Subject and Variable

The units of these activity means depend upon the units of the raw dataset feature
variables, which are explained in that source dataset’s README file.  For our 79
feature variables of interest, here are their units:

All of the activity means have mean values of standard gravity units for rows
that have the following in the Variable column:

"timeBodyAccelerationMeanX"                          
"timeBodyAccelerationMeanY"                         
"timeBodyAccelerationMeanZ"                                                 
"timeGravityAccelerationMeanX"                       
"timeGravityAccelerationMeanY"                      
"timeGravityAccelerationMeanZ"                                           
"timeBodyAccelerationJerkMeanX"                      
"timeBodyAccelerationJerkMeanY"                     
"timeBodyAccelerationJerkMeanZ"                         
"timeBodyAccelerationMagnitudeMean"                                 
"timeGravityAccelerationMagnitudeMean"                            
"timeBodyAccelerationJerkMagnitudeMean"                
"frequencyBodyAccelerationMeanX"                     
"frequencyBodyAccelerationMeanY"                    
"frequencyBodyAccelerationMeanZ"                                       
"frequencyBodyAccelerationMeanFreqX"                 
"frequencyBodyAccelerationMeanFreqY"                
"frequencyBodyAccelerationMeanFreqZ"                 
"frequencyBodyAccelerationJerkMeanX"                
"frequencyBodyAccelerationJerkMeanY"                 
"frequencyBodyAccelerationJerkMeanZ"                
"frequencyBodyAccelerationJerkMeanFreqX"            
"frequencyBodyAccelerationJerkMeanFreqY"             
"frequencyBodyAccelerationJerkMeanFreqZ" 
"frequencyBodyAccelerationMagnitudeMean"            
"frequencyBodyAccelerationMagnitudeMeanFreq"        
"frequencyBodyBodyAccelerationJerkMagnitudeMean"        
"frequencyBodyBodyAccelerationJerkMagnitudeMeanFreq" 

All of the activity means have mean values of standard deviations of standard gravity units 
for rows that have the following in the Variable column:

"timeBodyAccelerationStDevX"                        
"timeBodyAccelerationStDevY"                         
"timeBodyAccelerationStDevZ" 
"timeGravityAccelerationStDevX"                     
"timeGravityAccelerationStDevY"                      
"timeGravityAccelerationStDevZ" 
"timeBodyAccelerationJerkStDevX"                    
"timeBodyAccelerationJerkStDevY"                     
"timeBodyAccelerationJerkStDevZ"
"timeBodyAccelerationMagnitudeStDev" 		    
"timeGravityAccelerationMagnitudeStDev"
"timeBodyAccelerationJerkMagnitudeStDev"
"frequencyBodyAccelerationStDevX"                   
"frequencyBodyAccelerationStDevY"                    
"frequencyBodyAccelerationStDevZ" 
"frequencyBodyAccelerationJerkStDevX"                
"frequencyBodyAccelerationJerkStDevY"               
"frequencyBodyAccelerationJerkStDevZ"                
"frequencyBodyAccelerationMagnitudeStDev" 
"frequencyBodyBodyAccelerationJerkMagnitudeStDev"

All of the activity means have mean values of radians/second for rows
that have the following in the Variable column:   
              
"timeBodyGyroscopeMeanX"                             
"timeBodyGyroscopeMeanY"                            
"timeBodyGyroscopeMeanZ"                               
"timeBodyGyroscopeJerkMeanX"                         
"timeBodyGyroscopeJerkMeanY"                        
"timeBodyGyroscopeJerkMeanZ"                         
"timeBodyGyroscopeMagnitudeMean"                     
"timeBodyGyroscopeJerkMagnitudeMean"                 
"frequencyBodyGyroscopeMeanX"                        
"frequencyBodyGyroscopeMeanY"                       
"frequencyBodyGyroscopeMeanZ"                        
"frequencyBodyGyroscopeMeanFreqX"                    
"frequencyBodyGyroscopeMeanFreqY"   
"frequencyBodyGyroscopeMeanFreqZ"                    
"frequencyBodyBodyGyroscopeMagnitudeMean"           
"frequencyBodyBodyGyroscopeMagnitudeMeanFreq"       
"frequencyBodyBodyGyroscopeJerkMagnitudeMean"        
"frequencyBodyBodyGyroscopeJerkMagnitudeMeanFreq" 

All of the activity means have mean values of standard deviations of radians/second 
for rows that have the following in the Variable column:

"timeBodyGyroscopeStDevX"                           
"timeBodyGyroscopeStDevY"                            
"timeBodyGyroscopeStDevZ"
"timeBodyGyroscopeJerkStDevX"                       
"timeBodyGyroscopeJerkStDevY"                        
"timeBodyGyroscopeJerkStDevZ" 
"timeBodyGyroscopeMagnitudeStDev" 
"timeBodyGyroscopeJerkMagnitudeStDev" 
"frequencyBodyGyroscopeStDevX"                      
"frequencyBodyGyroscopeStDevY"                       
"frequencyBodyGyroscopeStDevZ"
"frequencyBodyBodyGyroscopeMagnitudeStDev" 
"frequencyBodyBodyGyroscopeJerkMagnitudeStDev"


We have the expected 2370 rows of tidy data as shown here:
> dim(tidyData)
[1] 2370    8

The first row of data is:
1  timeBodyAccelerationMeanX 0.22159824 0.261237565 0.27891763 0.27733076 0.289188320 0.255461690

Thus, for subject number 1, the mean value of timeBodyAccelerationMeanX for 
all of the rows of raw data for activity LAYING is 0.22159824 standard gravity units, 
for SITTING it’s 0.261237565, and so forth for all 2370 combinations of 30
subjects and 79 technical variables.

