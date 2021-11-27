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

#plot2
png(filename = "plot2.png")
plot(dataset$global_active_power ~ dataset$datetime, type="l", main = "", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()

#ggplot
#png(filename = "plot2.png")
#ggplot(dataset, aes(x=datetime, y=global_active_power)) +
#  geom_line() +
#  ylab(label = "Global Active Power") + 
#  xlab(label = "")
#dev.off()
