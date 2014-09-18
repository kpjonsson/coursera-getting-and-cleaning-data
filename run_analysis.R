## Download and extract data
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
#              destfile = 'project-data.zip', method = 'curl', quiet = T)
#
# unzip('project-data.zip')

## Read data
test_data = read.delim('UCI HAR Dataset/test/X_test.txt', header = F, sep = '')
test_labels = read.delim('UCI HAR Dataset/test/y_test.txt', header = F)
test_subjects = read.delim('UCI HAR Dataset/test/subject_test.txt', header = F)
train_data = read.delim('UCI HAR Dataset/train/X_train.txt', header = F, sep = '')
train_labels = read.delim('UCI HAR Dataset/train/y_train.txt', header = F, )
train_subjects = read.delim('UCI HAR Dataset/train/subject_train.txt', header = F)
features = read.delim('UCI HAR Dataset/features.txt', header = F, sep = '')
activities = read.delim('UCI HAR Dataset/activity_labels.txt', header = F, sep = '')

colnames(train_data) = features$V2 # Set the feature names as column names
colnames(test_data) = features$V2

## Merge data frames (instruction no. 1)
test = cbind(label = test_labels$V1, subject = test_subjects$V1, test_data)
train = cbind(label = train_labels$V1, subject = train_subjects$V1, train_data)

test_train = rbind(test, train)

## Extract mean/sd measurements only (instruction no. 2)
mean_idx = grep('mean', colnames(test_train))
sd_idx = grep('std', colnames(test_train))

test_train = test_train[, c(1, 2, mean_idx, sd_idx)]

## Label the acitvities (instruction no. 3 & 4)
test_train$label = as.factor(test_train$label)
levels(test_train$label) = activities$V2

## Create new data set consisting in averages (per activity and subject)
## of variables in previous set (instruction no. 5)
test_train_melt = reshape2::melt(test_train, id = c('label', 'subject'))
test_train_avgs = reshape2::dcast(test_train_melt, subject + label ~ variable, mean)

## Write the data
write.table(test_train_avgs, file = 'project_submission.txt', row.names = F)
