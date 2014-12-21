tidy
====
#Loading test dataset
ytest <- read.table("./test/y_test.txt")
Xtest <- read.table("./test/X_test.txt")
subjecttest <- read.table("./test/subject_test.txt")
#Merge the 3 Test datasets
testset <- data.frame(ytest,subjecttest,Xtest)

#Loading training dataset
ytrain <- read.table("./train/y_train.txt")
Xtrain <- read.table("./train/X_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")
#Merge the 3 Trainig datasets
trainset <- data.frame(ytrain,subjecttrain,Xtrain)

#Merge the 2 Datasest just created 
dataset <- rbind(testset,trainset)


#Assignment 2. Extracts only the measurements on the mean and standard deviation for each measurement.

featListTable <- read.table("./features.txt",stringsAsFactors=FALSE)
meanId <- grepl("mean",featListTable[,2], ignore.case=TRUE)
stdId <- grepl("std",featListTable[,2], ignore.case=TRUE)
feat2BKept <- meanId | stdId
featNames = featListTable[feat2BKept,2]
feat2BKept <- c(TRUE,TRUE,feat2BKept) #Keep also the 1st and 2nd column (y and subject)
extractedDataset <- dataset[,feat2BKept]

# ---- Assignment 3. ----
#Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("./activity_labels.txt") #Read activity names table
extractedDataset <- merge(extractedDataset,activityLabels,by.x="V1",by.y="V1",sort=FALSE) #join dataset with action names data
extractedDataset[,1] <- extractedDataset[,ncol(extractedDataset)]
extractedDataset <- extractedDataset[,1:ncol(extractedDataset)-1] # substitute activities ids with names

# ---- Assignment 4. ----
#Appropriately labels the data set with descriptive variable names.
featuresLabels <- read.table("./features.txt",stringsAsFactors=FALSE) #Read activity names table
featuresLabels <- featuresLabels[feat2BKept,2] #Select only the labels we are interested in
featuresLabels <- featuresLabels[!is.na(featuresLabels)]
featuresLabels <- c("Activity","Subject",featuresLabels)
colnames(extractedDataset) <- featuresLabels


# ---- Assignment 5. ----
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyDataset <- aggregate(extractedDataset[,3:ncol(extractedDataset)],by=list(Activity=extractedDataset$Activity,Subject=extractedDataset$Subject),FUN=mean,na.rm=TRUE)

tidydata<-write.table(tidyDataset,"./tidy.txt" , row.name=FALSE)
