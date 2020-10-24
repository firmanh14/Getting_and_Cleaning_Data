# Getting_and_Cleaning_Data
This repository is a repo for the peer grade assignment of the Getting and Cleaning the Data Course

I follow the step that explain in the question to complete the analyzis
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each
   measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with  
   the average of each variable for each activity and each subject.
   
The analysis was done by several steps
1. download the data by using download.file function
2. unzip the data
3. read the activity_labels.txt and features.txt
4. the featureWant is the featue that have the std and mean in their featureNames
5. then I read other data using fread form data.table package
6. and using rbind to merge both data
7. and tidy the data by using the mean of the data have the same different set     of subjectNum and ActivityClass   