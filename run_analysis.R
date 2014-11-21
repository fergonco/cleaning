# Read the data with descriptive variable names
features<-read.table("UCI HAR Dataset//features.txt", col.names = c("code", "featureName"))
measures<-read.table("UCI HAR Dataset//test//X_test.txt", col.names = features[,"featureName"])
measuresTrain<-read.table("UCI HAR Dataset//train//X_train.txt", col.names = features[,"featureName"])
measures<-rbind(measures, measuresTrain)

# Only mean and standard deviation
variableNames<-names(measures)
meanOrStdNames<-variableNames[grepl("mean\\Q...\\E", variableNames) | grepl("std\\Q...\\E", variableNames)]
measures<-measures[, names(measures) %in% meanOrStdNames]

# Add the activity
activityNames<-read.table("UCI HAR Dataset//activity_labels.txt", col.names = c("code", "name"))
activities = read.table("UCI HAR Dataset//test/y_test.txt", col.names = "code")
activitiesTrain = read.table("UCI HAR Dataset//train/y_train.txt", col.names = "code")
activities<-rbind(activities, activitiesTrain)
measures$activity <- sapply(activities$code, function(code) {activityNames$name[activityNames$code==code]})

# Add the subject of each measure
subject<-read.table("UCI HAR Dataset//test//subject_test.txt", col.names = "subject")
subjectTrain<-read.table("UCI HAR Dataset//train//subject_train.txt", col.names = "subject")
subject<-rbind(subject, subjectTrain)
measures$subject <- subject$subject

# Average of each variable for each activity and subject
melted<-melt(measures, id.vars = c("subject", "activity"), measure.vars = meanOrStdNames)
melted$subjectActivity<-paste(melted$subject, " - ", melted$activity)
averageByActivityAndSubject<-dcast(melted, subjectActivity ~ variable, mean)

