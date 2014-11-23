CodeBook.md
===========
 
##CodeBook
 
* act_labels: table with columns "activity_id" and "activity" which maps numbers to descriptions.
* features: contents of features.txt
* data: local variable used in function read_data() for holding the data of a given data set (test or train)
* all_data: data of both train and test data 
* data_per_act: this is "all_data" grouped by "activity", holding the mean() values of all columns.
* project-result.txt: the file where the result table is exported
