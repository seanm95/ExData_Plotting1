

## Raw Data Format

## 1 Date: Date in format dd/mm/yyyy 
## 2.Time: time in format hh:mm:ss 
## 3.Global_active_power: household global minute-averaged active power (in kilowatt) 
## 4.Global_reactive_power: household global minute-averaged reactive power (in kilowatt) 
## 5.Voltage: minute-averaged voltage (in volt) 
## 6.Global_intensity: household global minute-averaged current intensity (in ampere) 
## 7.Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). 
## 8.Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
## 9.Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.



library(data.table)

## Instructions: "Note that in this dataset missing values are coded as ?."

## Using fread to load file into data.table DT. This should be fast.
## fread initially makes columns 3 thru 8 as numeric. When it encounters question mark, it changes them 
##   to character and issue warnings. We use "suppressWarnings()" to hide the warnings
DT <- suppressWarnings(fread("..//household_power_consumption.txt",sep=";", header=TRUE, na.strings="?" ) )

## Instructions: "We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to 
##   read the data from just those dates rather than reading in the entire dataset and subsetting to those dates."

## Here we transfer to Data.Table DT2 the data we will use
DT2 <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007"]

## Instructions: "You may find it useful to convert the Date and Time variables to Date/Time classes in R 
## using the strptime() and as.Date() functions"

## Create Datetime column using Date and Time
Datetime <- strptime(paste(DT2$Date,DT2$Time),format="%d/%m/%Y %H:%M:%S")

## Move data to data.frame DF and add new column Datetime
DF <- cbind(as.data.frame(DT2), Datetime)

## Convert Date field from Character to a Date column
DF$Date <- as.Date(DF$Date,format="%d/%m/%y")

## Convert character fields to numeric for 3 thru 8
DF[,3] <- as.double( DF[,3] )
DF[,4] <- as.double( DF[,4] )
DF[,5] <- as.double( DF[,5] )
DF[,6] <- as.double( DF[,6] )
DF[,7] <- as.double( DF[,7] )
DF[,8] <- as.double( DF[,8] )
DF[,9] <- as.double( DF[,9] )

## Now we plot...

## Instructions: "Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels."
pngfile <- png(file="plot4.png", width=480, height=480, units="px", bg="transparent")

par(mfrow=c(2,2))

## 1
plot(DF[,"Datetime"], DF[,"Global_active_power"], type="l",  main="", ylab="Global Active Power", xlab="")

##2
plot(DF[,"Datetime"], DF[,"Voltage"], type="l",  main="", ylab="Voltage", xlab="datetime")

## 3
plot(DF[,"Datetime"], DF[,"Sub_metering_1"], type="l",  main="", ylab="Energy sub metering", xlab="")
points(DF[,"Datetime"], DF[,"Sub_metering_2"], type="l", col="red")
points(DF[,"Datetime"], DF[,"Sub_metering_3"], type="l", col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black","red","blue"), lty=1,
       bty="n")

##4
plot(DF[,"Datetime"], DF[,"Global_reactive_power"], type="l",  main="", ylab="Global_reative_power", xlab="datetime")

dev.off()
