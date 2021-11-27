library(vroom)
library(dplyr)
library(janitor)

#importing the dataset
dataset <- vroom::vroom(file = "household_power_consumption.txt")

#clean_names
dataset <- dataset %>%
clean_names()

#replace ? by NAs
dataset[dataset == "?"] <- NA

#selecting only specific dates
dataset$date <- as.Date(dataset$date, "%d/%m/%Y")
dataset <- dataset[(dataset$date == "2007-02-01" | dataset$date == "2007-02-02"), ]

#convert the dataset to numeric
dataset$global_active_power <- as.numeric(dataset$global_active_power)
dataset$global_reactive_power <- as.numeric(dataset$global_reactive_power)
dataset$global_intensity <- as.numeric(dataset$global_intensity)
dataset$voltage <- as.numeric(dataset$voltage)
dataset$sub_metering_1 <- as.numeric(dataset$sub_metering_1)
dataset$sub_metering_2 <- as.numeric(dataset$sub_metering_2)
dataset$sub_metering_3 <- as.numeric(dataset$sub_metering_3)

#plot1
png(filename = "plot1.png")
hist(dataset$global_active_power, col = "#CD2626", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()
     