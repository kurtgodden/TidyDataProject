# Tidy Data Project

This README explains at a high level how my run_analysis.R script works with the detailed description, including all code and output variables and their datatypes and units and all algorithmic descriptions, appearing in the accompanying CodeBook.md file.

The script downloads and the operates on raw data (UCI HAR dataset) taken from experiments from a group of human subjects designated only by the integers 1-30.  Each person wore a Samsung Galaxy S II smartphone on their waist, and data from the phone’s accelerometer and gyroscope sensors were obtained and processed while the subject engaged in six activities: Laying, Sitting, Standing, Walking Downstairs and Walking Upstairs.  The training and test datasets both contained 561 variables.

My task, and that of my script’s was to satisfy the following requirements:

“. . . create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.”

My interpretation of requirement 5 is that we are to compute the mean values of each of the 6 activities for every unique combination of test subject and measurement variable, e.g. test subject 1 and measurement variable tBodyAcc-mean()-X.  I also note that in the evaluation questions, the instructors state that, for the resulting tidy dataset, “Either a wide or a long form of the data is acceptable”.  

Thus, I chose to create a LONG FORM whereby there are only 8 columns of data, but 2370 rows.

The 8 columns are called:
  Subject 
  Variable  
  LayingMean  
  SittingMean 
  StandingMean 
  WalkingMean 
  WalkingDownstairsMean  
  WalkingUpstairsMean

and each row represents one observation for a unique combination of one of the 30 test Subjects and one of the 79 measurement variables that refer to data means or standard deviations, as stated in requirement #2 above.  We expect 2370 rows of data because that is the number of unique combinations of subjects and measurement variables, i.e. 30 * 79 = 2370

The run_analysis.R script is broken into the following 5 logical blocks:

1. Download the raw data from the web and unzip it to a local directory under my R working directory.

2. Extract data from 8 of the UCI HAR files that are needed to fulfill the requirements of the project assignment.  The details regarding those 8 files are explained in the accompanying CodeBook.md file.

3. Obtain the measurement variables of interest from the UCI HAR dataset, i.e. the 79 variables that refer either to mean measurements or standard deviations, and rename them to be more descriptive than the original raw data names.  These are subsetted out of the raw training and test data and stored as data frames in the R variables trainingDataMeansStds and testsDataMeansStds.

4. To the data frames just extracted with 79 columns of measurement variables, add new columns for test subjects and activities, where the activities use descriptive text labels (e.g. SITTING) rather than the numeric labels that appear in the raw UCI HAR data.  Lastly, in this code section, I merged the two modified training and test datasets into one dataframe called ‘mergeDataAll’.  This represents the output referred to from step #4 in the requirements above.

5. The final code block operates on mergedDataAll to create the final tidy data set by looping on the 30 test subjects and the 79 measurement variables to obtain the 2370 required rows of data.  Most of the work is done by a defined function called ‘computerVarMeans’ that is called with mergedDataAll as its argument.  The output from this function is then cleaned up slightly, the 6 activity columns slightly renamed and the final tidy dataset is saved as the value of the variable ‘tidyData’.  This data is then written to an external file called ‘MyTidyData.txt’.

Again, there is much more detail about the processing of each of the 5 code blocks in CodeBook.md.  That code book is liberally commented to assist not only readability, but also to point out dimensions of various dataframes and other information, e.g. the date/time stamp when I downloaded the UCI HAR dataset from the web.

NOTE: I did discover during the project that 2 of those 79 variables contain duplicate data, viz. timeBodyAccelerationMagnitudeMean and timeGravityAccelerationMagnitudeMean, as I am referring to them in my ‘tidy’ naming convention.  Since it is not possible to tell which (or whether both) is incorrect, I simply chose to retain both variables, but point out the duplication here in this description. 

