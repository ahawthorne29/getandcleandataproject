# getandcleandataproject
Getting and Cleaning Data Course Project

The run_analysis.R file provides all the commands required in R to take the raw data for the course project and clean it as directed.
The data has already been downloaded onto my PC.
In the script I load the appropriate R packages for working with the data.
I read the data into a number of dataframes.

Then I set the names of the columns as per the file given.

The next job is to attach the subject and activity variables to the train and test dataframes and then append one dataframe to the other so that all the data is in one dataframe.

The next step removes the varaibales that aren't the key ones (i.e. subject id and activity id) and that aren't concerned with mean or standard deviation. This is performed by examining the variable names.

Now that I have a nice subset, I replace the numbers 1-6 that are the values of the Activity column with the names of the corresponding activities as per the raw datafile activity_labels.txt.

Now that the data is ship-shape, I make the column names more readable by removing spurious characters, replacing abbreviations with full words and making all lower case. This is as per the instructions in the week 4 lectures of the course.

The next big job is to make a tidy dataset that produces a variable average (mean) for each of the variables on a per subject and per activity level.
To do this I first make the activity variables factors so I can group by them.
I also initalise my new dataset.
Next I have written a 'for' loop so that I can easily treat each of the 30 subjects separately.
For each subject, I subset the dataframe to just their data and then I group their data by the activities. Then I use the melt and dcast commands to produce column means as requires.
I then append these to my nice new mytidyaverages dataset.

Finished!


