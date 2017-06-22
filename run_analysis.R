library(dplyr)
library(reshape2)
setwd("D:/Data/Academic/Coursera/R/02.-Data Scients with R/03.-Getting and Cleaning Data/W4/08.-Project/UCI HAR Dataset")

activityLabels <- read.table("activity_labels.txt")
str(activityLabels)
dim(activityLabels)
activityLabels$V2<-as.character(activityLabels$V2)

features <- read.table("features.txt")
features$V2<-as.character(features$V2)

features$V2<-gsub("-","_",features$V2)
features$V2<-gsub("[()]","",features$V2)
head(features$V2)

X_train<-read.table("train/X_train.txt")
colnames(X_train)<-features$V2
X_train<-X_train[,grep(".*mean.*|.*std.*", features$V2)]


X_test<-read.table("test/X_test.txt")
colnames(X_test)<-features$V2
X_test<-X_test[,grep(".*mean.*|.*std.*", features$V2)]


y_train <- read.table("train/y_train.txt")
y_train$V1<-as.factor(y_train$V1)
levels(y_train$V1)<-activityLabels$V2
y_train <- rename(y_train, activity = V1)



y_test <- read.table("test/y_test.txt")
y_test$V1<-as.factor(y_test$V1)
levels(y_test$V1)<-activityLabels$V2
y_test <- rename(y_test, activity = V1)



subject_train <- read.table("train/subject_train.txt")
subject_train <- rename(subject_train, subject = V1)

subject_test <- read.table("test/subject_test.txt")
subject_test <- rename(subject_test, subject = V1)

train <- data.frame(subject_train, y_train, X_train)
names(train)

test <- data.frame(subject_test, y_test, X_test)
names(test)

merge_data <- rbind.data.frame(train,test)
merge_data$subject<-as.factor(merge_data$subject)

melt_data <- melt(merge_data)

tidy<-dcast(melt_data, subject + activity ~ variable, mean)

write.table(tidy, "tidy.txt",row.name=FALSE)


