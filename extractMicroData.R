#process the microData from South Africa

#Library to open .dta files
library("foreign", lib.loc="C:/Program Files/R/R-3.4.1/library")
library("memisc", lib.loc="~/R/win-library/3.4")

#set working directory
setwd("C:/Users/Ana/Desktop/TUM/CapeTown/SynPop")

#read the csv file with the attributes to extract
path<-"microData"

fileNames = c("censusHousehold.dta","censusPerson.dta", "censusPerson.sav")

codes <- c(199, 164, 166, 167)
names <- c("City of Cape Town", "Swartland", "Drakenstein", "Stellenbosch")

#for households-----------

fileName = paste(path, fileNames[1], sep = "/")
data <- read.dta(fileName)
name = substr(fileName, 1, nchar(fileName) - 4)
fileName1 = paste(name, "csv", sep = ".")
write.csv(data,fileName1)

data3 <- subset(data, H_MUNIC == "City of Cape Town")
data4 <- subset(data, H_MUNIC == "Swartland")
data5 <- subset(data, H_MUNIC == "Drakenstein")
data6 <- subset(data, H_MUNIC == "Stellenbosch")
dataAll <- rbind(data3, data4, data5, data6)

name = substr(fileName, 1, nchar(fileName) - 4)
fileName1 = paste(name, "all","csv", sep = ".")
write.csv(dataAll,fileName1)


#for persons-----------

fileName = paste(path, fileNames[3], sep = "/")
data <- spss.system.file(fileName)

data1 <- subset(data, p_province == "Western cape")
name = substr(fileName, 1, nchar(fileName) - 4)
fileName1 = paste(name, "csv", sep = ".")
write.csv(data1,fileName1)

columns <- c(1,2,3,4,5,9,10,12,15,18,24,42,43,44,46,54,81,91,93,96)
data2 <- data1[,columns]

data3 <- subset(data2, p_munic == "City of Cape Town")
data4 <- subset(data2, p_munic == "Swartland")
data5 <- subset(data2, p_munic == "Drakenstein")
data6 <- subset(data2, p_munic == "Stellenbosch")
dataAll <- rbind(data3, data4, data5, data6)

name = substr(fileName, 1, nchar(fileName) - 4)
fileName2 = paste(name,"all2", "csv", sep = ".")
write.csv(dataAll,fileName2)


#remove the households that don't have persons or persons without household
households <- read.csv(fileName1)
persons <- read.csv(fileName2)
new <- merge(households, persons, by.x = 'SN', by.y = 'sn')
write.csv(new, "completePersons.csv")

newPersons <- new[,58:76]
newPersons <- cbind(newPersons, new$X.x)
newPersons$p20_edulevel <- gsub(",","",newPersons$p20_edulevel)
write.csv(newPersons, "newPersons.csv")

newPersons1[is.na(newPersons)] <-""
newPersons1 <- sapply(newPersons, as.character)
newPersons1[is.na(newPersons1)]<- ""
write.csv(newPersons1, "newPersons1.csv")

newHouseholds <- new[, 1:57]
newHouseholds1 <- newHouseholds[!duplicated(newHouseholds),]
newHouseholds1$H02_MAINDWELLING <- gsub(",","",newHouseholds1$H02_MAINDWELLING)
newHouseholds1$H02_OTHERDWELLING <- gsub(",","",newHouseholds1$H02_OTHERDWELLING)
write.csv(newHouseholds1, "newHouseholds.csv")


