library(data.table)

datadir <- 'UCI HAR Dataset'

if (!file.exists(datadir)) {
    stop(paste("directory not ound", datadir))
}

datadir <- paste(datadir, '/', sep='')

## get activity labels
act_labels <- fread(paste(datadir, 'activity_labels.txt', sep=''), stringsAsFactor = TRUE, header = FALSE)
setnames(act_labels, c("activity_id", "activity"))
setkey(act_labels, activity_id)

## get features
features <- fread(paste(datadir, 'features.txt', sep=''), stringsAsFactor = TRUE, header = FALSE)

## this function reads the data for a given type (test or train)
read_all_data <- function (type = 'test') {
    file_data     = paste(datadir, type, '/X_', type, '.txt', sep='')
    file_activity = paste(datadir, type, '/y_', type, '.txt', sep='')

    data <- as.data.table(read.table(file_data, header=FALSE, nrows=-1))

    setnames(data, features$V2);

    data <- subset(data, select = grep('-mean|-std', names(data)))

    activity = fread(file_activity, header = FALSE, nrows=-1)
    setnames(activity, 1, 'activity_id')

    data[,activity_id:=activity$activity_id] 

    setkey(data, activity_id)
    data <- merge(data, act_labels)
    data[,activity_id := NULL]

	#return result
    data
}

## merge test and train data
all_data <- rbindlist(
    list(read_all_data(type='test'), read_all_data(type='train')), use.names=FALSE, fill = FALSE)

## group data by activity
setkey(all_data, activity)
data_per_act <- all_data[, lapply(.SD, mean), by = activity]

## export results to file
fn <- "project-result.txt"
write.table(data_per_act, row.names = FALSE, file=fn)
cat(paste("data was exported to file \"", fn, "\" \n", sep="")) 
