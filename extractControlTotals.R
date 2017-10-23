#Process control totals from South Africa

#Library to open .dta files
library("foreign", lib.loc="C:/Program Files/R/R-3.4.1/library")

#set working directory
setwd("C:/Users/Ana/Desktop/TUM/CapeTown/SynPop")

#read the csv file with the attributes to extract
attributes<-read.csv("ListAttributes.csv")
path<-"controlTotals"

#go through the list, read the .dta file, subset for the metropolitan area of Cape Town and store as .csv
finish = 0
initialRow = 2
fileNameAll = paste(path, "attributes.csv", sep = "/")

while (finish == 0 & initialRow <= nrow(attributes)){
  
  if (attributes[initialRow, 2] == FALSE){
    
    initialRow = initialRow + 1
    
  } else {
    
    finish = 1
    fileName = paste(path,attributes[initialRow,1],sep = "/")
    data <- read.dta(fileName)
    data1 <- subset(data, mn_code == 199) 
    data2 <- subset(data, mn_code == 164)
    data3 <- subset(data, mn_code == 166)
    data4 <- subset(data, mn_code == 167)
    dataAll <- rbind(data1, data2, data3, data4)
    name = substr(fileName, 1, nchar(fileName) - 4)
    fileName = paste(name, "csv", sep = ".")
    write.csv(dataAll,fileName)
    initialRow = initialRow + 1
    
    rm(data, data1, data2, data3, data4)
    
  }
  
}

for (i in initialRow:nrow(attributes)){
  
  if (attributes[i,2] == TRUE){
    
    fileName = paste(path,attributes[i,1],sep = "/")
    dataA <- read.dta(fileName)
    data1 <- subset(dataA, mn_code == 199) 
    data2 <- subset(dataA, mn_code == 164)
    data3 <- subset(dataA, mn_code == 166)
    data4 <- subset(dataA, mn_code == 167)
    dataB <- rbind(data1, data2, data3, data4)
    
    
    name = substr(fileName, 1, nchar(fileName) - 4)
    fileName = paste(name, "csv", sep = ".")
    write.csv(dataB,fileName)
    
    dataC <- dataB[, 14:ncol(dataB)]
    dataAll <- cbind(dataAll, dataC)
    write.csv(dataAll,fileNameAll)
    
    rm(dataA, data1, data2, data3, data4, dataB, dataC,fileName)
    
  }
  
}

