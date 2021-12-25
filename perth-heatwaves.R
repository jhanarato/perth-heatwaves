# Using data from the Bureau of Meteorology visualise the history 
# of heatwaves in Perth, Western Australia.
#
# Created by Ajahn Jhanarato, 2021.

library(tidyverse)

temp_data <- read_csv("perth-temp.csv",
                      col_names = c("product", "station", 
                                    "year", "month", "day",
                                    "max_temp", "period", "quality"),
                      col_types = list(
                        year = col_integer(), 
                        month = col_integer(),
                        day = col_integer(),
                        max_temp = col_double()
                        ),
                      skip = 1)


temp_data <- temp_data %>% 
  select(year, month, day, max_temp) %>%
  na.omit()
