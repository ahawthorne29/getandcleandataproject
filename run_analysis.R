##This program cleans and tidies the data outlined here http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##The program will read the data files, add labels, join the data and tidy it up

## load the packages we need

      library(dplyr)
      library(tidyr)
      library(reshape2)

##read in the raw data and add column names from the labelling files

      mytrain <- read.table("project_data/train/X_train.txt")
      mytrainsub <- read.table("project_data/train/subject_train.txt")
      names(mytrainsub) <- "Subject"
      mytrainlabs <- read.table("project_data/train/Y_train.txt")
      names(mytrainlabs) <- "Activity"
      mytest <- read.table("project_data/test/X_test.txt")
      mytestsub <- read.table("project_data/test/subject_test.txt")
      names(mytestsub) <- "Subject"
      mytestlabs <- read.table("project_data/test/Y_test.txt")
      names(mytestlabs) <- "Activity"
      mynames <- read.table("project_data/features.txt")
      names(mytrain) <- mynames[,2]
      names(mytest) <- mynames[,2]

##Now we need to add the Subject and Activity columns to the dataset

      mytrain <- cbind(mytrainlabs,mytrain)
      mytrain <- cbind(mytrainsub,mytrain)
      mytest <- cbind(mytestlabs, mytest)
      mytest <- cbind(mytestsub, mytest)

##Now we will append the test data to the training data. As the column names match exactly and we dont want to lose any rows
##we will use rbind

      mydata <- rbind(mytrain, mytest)

##Now we want to create a subset only containing the key data (Activity & Subject) and means or standard deviations

      ## toMatch <- c("Mean", "mean", "std", "STD", "Activity", "Subject") ##removed as includes variables we don't want
      toMatch <- c("mean", "std", "Activity", "Subject")
      mysubset <- mydata[,grep(paste(toMatch, collapse="|"), names(mydata))]

##now we want to replace the values in the Activity column with the corresponding activity labels


      myactivities <- read.table("project_data/activity_labels.txt")
      myacts <- as.character(myactivities[,2])

      for (i in seq_along(mysubset$Activity)) {
              ## for reasons I can't fathom - this didn't work so replacing with an ugly if statement
              ##   mysubset$Activity[i] <- myacts[mysubset$Activity[i]]
              if (mysubset$Activity[i] == 1) {
                  mysubset$Activity[i] <- "WALKING"
              }
              else if (mysubset$Activity[i] == 2) {
                mysubset$Activity[i] <- "WALKING_UPSTAIRS"
      
              }
              else if (mysubset$Activity[i] == 3) {
                mysubset$Activity[i] <- "WALKING_DOWNSTAIRS"
      
              }
              else if (mysubset$Activity[i] == 4) {
                mysubset$Activity[i] <- "SITTING"
      
              }
              else if (mysubset$Activity[i] == 5) {
                mysubset$Activity[i] <- "STANDING"
      
              }
              else if (mysubset$Activity[i] == 6) {
                mysubset$Activity[i] <- "LAYING"
      
              }
        
      }

## tidy up the names of the dataset and make more readable
      names(mysubset) <- tolower(names(mysubset))  ##make them lower case
      ##replace abbreviations with full names
      names(mysubset) <- sub("std","stanarddeviation",names(mysubset))  
      names(mysubset) <- sub("fbody","frequencybody",names(mysubset)) 
      names(mysubset) <- sub("acc","acceleration",names(mysubset)) 
      names(mysubset) <- sub("tbody","timebody",names(mysubset)) 
      names(mysubset) <- sub("acc","acceleration",names(mysubset)) 
      ##remove spurious characters
      names(mysubset) <- gsub("-","",names(mysubset))
      names(mysubset) <- sub("\\(","",names(mysubset))
      names(mysubset) <- sub("\\)","",names(mysubset))
      
      
##make a new dataset containing the average of each variable for each subject by activity

##make the activity variable a factor so I can group by it            
      mysubset$activity <- as.factor(mysubset$activity)
      
##initalise a newdataset to put the averages into
      
      mytidyaverages <- data.frame(matrix(ncol=81,nrow=0))
      names(mytidyaverages) <- names(mysubset)
      
##for each subject create a subset of the dataset to work with
##loop through this and pull out the column means and add them to the new tidy averages dataset
      
      for (i in 1:30) {
              mydat <- filter(mysubset, subject == i)
              mydat <- group_by(mydat, activity)
              dm = melt(mydat, id.vars = "activity")
              dmg=group_by(dm, activity, variable)
              x = summarise(dmg, means=mean(value))
              newdat <- dcast(x, activity~variable)
              mytidyaverages <- rbind(mytidyaverages,newdat)
      }
      
      
