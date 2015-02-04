# load required libraries
print("Load dplyr library")
library(dplyr)

# Create working directory if doesn't exist
cwd <- getwd()
print(paste("Current working directory:", cwd))
if(!file.exists("./exdataproj1")) {dir.create("./exdataproj1")}
setwd(paste(cwd,"exdataproj1",sep="/"))
print (paste("Changed working directory:", getwd()))

# Download the data package and unzip into working directory
if(!file.exists("household_power_consumption.txt")) {
file_location <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
print(paste("Downloading file from location:", file_location))
download.file(file_location, destfile="Dataset.zip", method="curl", quiet=TRUE)
print("Download complete")
print("Unzipping downloaded files")
unzip(zipfile="Dataset.zip")
print("Unzip complete")
}
# find memory requirements
file.size=file.info("household_power_consumption.txt")$size
memory.size=file.size/1024/1024
print("Memory required to load data in MB is ")
print(memory.size)

# read the household power consumption data
datapc <- tbl_df(read.csv("household_power_consumption.txt",header=TRUE, sep=";", na.strings="?"))

# filter for the dates needed for analysis
dates.needed <- c("1/2/2007", "2/2/2007")
datapc.sub <- filter(datapc, Date %in% dates.needed)

# convert Date and Time field to timestamp attribute and add to the table as column
datapc.sub.mutate <- mutate(datapc.sub, datetimestamp = as.POSIXct(paste(as.Date(Date, "%d/%m/%Y"), Time)))

# create plot of sub metering 
png("plot3.png", height=480, width=480)
plot(as.numeric(datapc.sub.mutate$Sub_metering_1)~datapc.sub.mutate$datetimestamp, type="l", ylab="Energy sub metering", xlab="")
lines(as.numeric(datapc.sub.mutate$Sub_metering_2)~datapc.sub.mutate$datetimestamp, type="l", col="red")
lines(as.numeric(datapc.sub.mutate$Sub_metering_3)~datapc.sub.mutate$datetimestamp, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
dev.off()

# set working directory back to previous
setwd(cwd)