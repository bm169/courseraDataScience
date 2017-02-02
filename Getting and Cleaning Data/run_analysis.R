#***********Loading all required libraries
library(data.table)
library(dplyr)
library(reshape2)

#***************************Downloading file and unzip it***************************************************

#Download folder from url provided
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = file.path(getwd(),filename),mode="wb")

#Unzip folder
if(file.exists(filename))
{
  filepath <- unzip(filename)
}
#Read all the paths of files in filepath vector
filepath
#output ----
# [1] "./UCI HAR Dataset/activity_labels.txt"                         
# [2] "./UCI HAR Dataset/features.txt"                                
# [3] "./UCI HAR Dataset/features_info.txt"                           
# [4] "./UCI HAR Dataset/README.txt"                                  
# [5] "./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
# [6] "./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
# [7] "./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
# [8] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
# [9] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
# [10] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
# [11] "./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
# [12] "./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
# [13] "./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
# [14] "./UCI HAR Dataset/test/subject_test.txt"                       
# [15] "./UCI HAR Dataset/test/X_test.txt"                             
# [16] "./UCI HAR Dataset/test/y_test.txt"                             
# [17] "./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
# [18] "./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
# [19] "./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
# [20] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
# [21] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
# [22] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
# [23] "./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
# [24] "./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
# [25] "./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
# [26] "./UCI HAR Dataset/train/subject_train.txt"                     
# [27] "./UCI HAR Dataset/train/X_train.txt"                           
# [28] "./UCI HAR Dataset/train/y_train.txt"    


#***********Read the features.txt file to get the column index for mean and std deviation*******************

feature<- fread(filepath[2], col.names = c("index", "feature") )

# get vector of index that have feature as mean() or std()
mean_std_feature <- grep("\\bmean\\b|\\bstd\\b", feature$feature)
mean_std_feature <- as.numeric(mean_std_feature)
# Also get the names of the features to be utilized in further analysis
mean_std_feature_names <- feature[mean_std_feature,2] #returned is a dataframe with one column and 66 observations
#to set column names of test dataset as features need to convert dataframe into vector of characters
mean_std_feature_names <- mean_std_feature_names$feature

#***********Reading train data from X_train.cltxt and y_train.txt. Merging the two datasets******************

#read only required feature columns with column names
train <- fread(filepath[27], select = mean_std_feature, col.names = mean_std_feature_names)

#Get Activity level for train data from y_train.txt
trainact <- fread(filepath[28],col.names = "activity")

#Get Subject for train data from subject_train.txt
trainsubj <- fread(filepath[26],col.names = "subject")

train_final <- cbind(train,trainact,trainsubj)


#***********Reading test data from X_test.cltxt and y_test.txt. Merging the two datasets******************

#read only required feature columns with column names
test <- fread(filepath[15], select = mean_std_feature, col.names = mean_std_feature_names)

#Get Activity level for test data from y_test.txt
testact <- fread(filepath[16],col.names = "activity")

#Get Subject for test data from subject_test.txt
testsubj <- fread(filepath[14],col.names = "subject")

test_final <- cbind(test,testact,testsubj)

#merge the train and test datasets
data <- rbind(train_final,test_final)

#***************Use descriptive activity names to name the activities in the data set ********************

#get activity labels from activity_labels.txt
activitylabel <- read.table(filepath)
#get labls of activity in activity column in data dataset
data$activity <- factor(data$activity, levels = activitylabel[,1], labels = activitylabel[,2])


#**** create independent tidy data set with the average of each variable for each activity and each subject*************

tidydata <- melt(data, id = c("activity", "subject"))
tidydata <- dcast(tidydata, subject + activity ~ variable, mean)

#****** writing data into tidydata.txt*****************************************

write.table(tidydata, file = "tidydata.txt" ,row.names = FALSE,quote = FALSE)




