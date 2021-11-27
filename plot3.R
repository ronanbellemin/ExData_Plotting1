library(vroom)
library(dplyr)
library(janitor)
library(lubridate)
library(tidyverse)

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

#replacing weekdays names
dataset<- dataset %>% 
  mutate(weekday = case_when(
    weekdays(date) %in% c("Jeudi") ~ "Thursday",
    weekdays(date) %in% c("Vendredi") ~ "Friday",
    weekdays(date) %in% c("Samedi") ~ "Saturday"
  ))

#unite date & time column
dataset <- unite(dataset, date, time, col = "datetime", sep = " ")
dataset$datetime <- as.POSIXct(dataset$datetime)

#plot3
png(filename = "plot3.png")
plot(dataset$sub_metering_1 ~ dataset$datetime, type="l", ylab = "Energy sub metering", xlab = "", col = "black")
lines(dataset$sub_metering_2 ~ dataset$datetime, type = "l", col = "red")
lines(dataset$sub_metering_3 ~ dataset$datetime, type = "l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))
dev.off()
