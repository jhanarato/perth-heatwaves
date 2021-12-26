# Using data from the Bureau of Meteorology visualise the history 
# of heatwaves in Perth, Western Australia.
#
# Created by Ajahn Jhanarato, 2021.

library(tidyverse)
library(lubridate)

# Import the BOM maximum temperature data.
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
  na.omit() %>% 
  mutate(bom_date = make_date(year, month, day)) %>% 
  filter(max_temp >= 40) %>%
  select(bom_date, max_temp)

# A heatwave can be defined as 2 or more days of 40C or over.
# If the previous 40+ day is yesterday, or the next is tomorrow
# then we're part of a heatwave.
heatwaves <- temp_data %>%
  mutate(
    hot_yesterday = lag(bom_date) == bom_date - 1,
    hot_tomorrow = lead(bom_date) == bom_date + 1,
    heatwave = hot_yesterday | hot_tomorrow
  ) %>%
  na.omit() %>%
  filter(heatwave) %>%
  select(bom_date, max_temp)

# Give each heatwave an identifier
heatwaves <- heatwaves %>%
  mutate(
    increment = case_when(
      is.na(lag(bom_date)) ~ TRUE,
      lead(bom_date) - bom_date == 1 ~ FALSE,
      lead(bom_date) - bom_date > 1 ~ TRUE
    ),
    heatwave_id = cumsum(increment)
  ) %>%
  select(-increment)

# Get start date and duration of each heatwave.
heatwave_stats <- heatwaves %>%
  group_by(heatwave_id) %>%
  summarise(
    start = as.character(min(bom_date)),
    num_days = length(bom_date),
    max_temp = max(max_temp)
  ) %>%
  arrange(desc(num_days))

heatwave_stats %>% 
  slice_head(n = 5) %>%
  ggplot() + geom_col(aes(x = start, 
                          y = num_days), fill = "lightsteelblue4") +
  labs(
    title = "Perth Heatwaves",
    x = "Date Heatwave Began",
    y = "Consecutive days over 40C"
  ) +
  scale_y_continuous(limits = c(0, 6), breaks = c(0:6)) +
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5, 
                                  size = 20))
