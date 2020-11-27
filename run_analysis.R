if(!file.exists("./data")){dir.create("./data")}
wdd<-paste(getwd(),"data",sep = "/")
zfile<-paste(wdd, "UCIHARDataset.zip", sep = "/")
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile ="./data/UCIHARDataset.zip", method = "curl")
unzip(zipfile = zfile, exdir = wdd )
if (file.exists(zfile)){
  file.remove(zfile)
}
library(dplyr)