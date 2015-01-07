# Assignment 1
test_y <- read.table("./test/y_test.txt")
test_x <- read.table("./test/X_test.txt")
test_subj <- read.table("./test/subject_test.txt")
test_set <- data.frame(test_y,test_subj,test_x)
train_y <- read.table("./train/y_train.txt")
train_x <- read.table("./train/X_train.txt")
subject_train <- read.table("./train/subject_train.txt")
train_set <- data.frame(train_y,subject_train,train_x)
dataset <- rbind(test_set,train_set)

# Assignment 2
list_table <- read.table("./features.txt",stringsAsFactors=FALSE)
id_mean <- grepl("mean",list_table[,2], ignore.case=TRUE)
id_std <- grepl("std",list_table[,2], ignore.case=TRUE)
kept <- id_mean | id_std
names = list_table[kept,2]
kept <- c(TRUE,TRUE,kept)
extr_set <- dataset[,kept]

# Assignment 3
lab_act <- read.table("./activity_labels.txt") 
extr_set <- merge(extr_set,lab_act,by.x="V1",by.y="V1",sort=FALSE) 
extr_set[,1] <- extr_set[,ncol(extr_set)]
extr_set <- extr_set[,1:ncol(extr_set)-1] 

# Assignment 4
lab_feat <- read.table("./features.txt",stringsAsFactors=FALSE)
lab_feat <- lab_feat[kept,2] 
lab_feat <- lab_feat[!is.na(lab_feat)]
lab_feat <- c("Activity","Subject",lab_feat)
colnames(extr_set) <- lab_feat


# Assignment 5
tidy <- aggregate(extr_set[,3:ncol(extr_set)],by=list(Activity=extr_set$Activity,Subject=extr_set$Subject),FUN=mean,na.rm=TRUE)
tidy_data<-write.table(tidy,"./tidy.txt" , row.name=FALSE)
