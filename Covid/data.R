library(lubridate)
library(tidyverse)

root = "https://raw.githubusercontent.com/"
repo = "CSSEGISandData/COVID-19"
folder = "/master/csse_covid_19_data/csse_covid_19_time_series/"

url_data_folder = str_c(root, repo, folder, sep="")

url_confirmed_US = str_c(
  url_data_folder, "time_series_covid19_confirmed_US.csv", sep="")
url_confirmed_global = str_c(
  url_data_folder, "time_series_covid19_confirmed_global.csv", sep="")
url_death_US = str_c(
  url_data_folder, "time_series_covid19_deaths_US.csv", sep="")
url_death_global = str_c(
  url_data_folder, "time_series_covid19_deaths_global.csv", sep="")
url_recovered_global = str_c(
  url_data_folder, "time_series_covid19_recovered_global.csv", sep="")


# read csv files 
confirmed_us_df = read_csv(url_confirmed_US)
death_us_df = read_csv(url_death_US)

confirmed_global_df = read_csv(url_confirmed_global)
death_global_df = read_csv(url_death_global)
recovered_global_df = read_csv(url_recovered_global)


#rename variables 

confirmed_us_df = confirmed_us_df %>% 
  rename(Long = 'Long_',
         County = 'Admin2')

death_us_df = death_us_df %>% 
  rename(Long = 'Long_',
         County = 'Admin2')

confirmed_global_df = confirmed_global_df %>% 
  rename(Province_State = "Province/State",
         Country_Region = "Country/Region")

death_global_df = death_global_df %>% 
  rename(Province_State = "Province/State",
         Country_Region = "Country/Region")

recovered_global_df = recovered_global_df %>% 
  rename(Province_State = "Province/State",
         Country_Region = "Country/Region")

#select columns 
confirmed_us_df = confirmed_us_df %>% 
  select(-(1:5))

death_us_df = death_us_df %>% 
  select(-(1:5))


#combine all dates into two columns: two date and metric (confirmed, death, recovered)
confirmed_us_df = confirmed_us_df %>% 
  gather(which(colnames(confirmed_us_df)=="1/22/20"):ncol(confirmed_us_df), 
         key = "date", value = "confirmed")

death_us_df = death_us_df %>% 
  gather(which(colnames(death_us_df)=="1/22/20"):ncol(death_us_df), 
         key = "date", value = "death")

confirmed_global_df = confirmed_global_df %>% 
  gather(which(colnames(confirmed_global_df)=="1/22/20"):ncol(confirmed_global_df), 
         key = "date", value = "confirmed")

death_global_df = death_global_df %>% 
  gather(which(colnames(death_global_df)=="1/22/20"):ncol(death_global_df), 
         key = "date", value = "death")

recovered_global_df = recovered_global_df %>% 
  gather(which(colnames(recovered_global_df)=="1/22/20"):ncol(recovered_global_df), 
         key = "date", value = "recovered")

# adjust date 
confirmed_us_df = confirmed_us_df %>% 
  mutate(date = mdy(date)) %>%
  mutate(
    weekday = weekdays(date), #a column for the weekday of the date
    month = month(date), #a column for the month of the date
    day = day(date), #a column for the month of the date
    year = year(date)
  )

death_us_df = death_us_df %>% 
  mutate(date = mdy(date)) %>% 
  mutate(
    weekday = weekdays(date), #a column for the weekday of the date
    month = month(date), #a column for the month of the date
    day = day(date), #a column for the month of the date
    year = year(date)
  )

confirmed_global_df = confirmed_global_df %>% 
  mutate(date = mdy(date)) %>% 
  mutate(
    weekday = weekdays(date), #a column for the weekday of the date
    month = month(date), #a column for the month of the date
    day = day(date), #a column for the month of the date
    year = year(date)
  )

death_global_df = death_global_df %>% 
  mutate(date = mdy(date)) %>% 
  mutate(
    weekday = weekdays(date), #a column for the weekday of the date
    month = month(date), #a column for the month of the date
    day = day(date), #a column for the month of the date
    year = year(date)
  )

recovered_global_df = recovered_global_df %>% 
  mutate(date = mdy(date)) %>% 
  mutate(
    weekday = weekdays(date), #a column for the weekday of the date
    month = month(date), #a column for the month of the date
    day = day(date), #a column for the month of the date
    year = year(date)
  )

# combine all counties into state for metric 
confirmed_us_df = confirmed_us_df %>% 
  group_by(Country_Region, Province_State, date, month, day, weekday, year) %>% 
  summarise(Lat = mean(Lat), Long = mean(Long), 
            confirmed = sum(confirmed), 
            .groups = 'drop')

death_us_df = death_us_df %>% 
  group_by(Country_Region, Province_State, date, month, day, weekday, year) %>% 
  summarise(Lat = mean(Lat), Long = mean(Long), 
            death = sum(death), 
            .groups = 'drop')

#join tables to get us table 
df_us = confirmed_us_df %>%
  full_join(death_us_df) %>%
  rename(region = `Country_Region`,
         sub_region = `Province_State`) %>% 
  select(region, sub_region, Lat, Long, 
         date, confirmed, death, month, 
         day, weekday, year)


df_global = confirmed_global_df %>%
  full_join(death_global_df) %>%
  rename(region = `Country_Region`,
         sub_region = `Province_State`) %>% 
  select(region, sub_region, Lat, Long, 
         date, confirmed, death, month, 
         day, weekday, year)

# temp all 
confirmed_cases_all = confirmed_global_df %>% 
  rename(region = `Country_Region`,
         sub_region = `Province_State`) %>% 
  group_by(region,date) %>%
  summarise(confirmed = sum(confirmed), .groups = 'drop')

recovered_cases_all = recovered_global_df %>% 
  rename(region = `Country_Region`,
         sub_region = `Province_State`) %>% 
  group_by(region,date) %>%
  summarise(recovered = sum(recovered), .groups = 'drop')

deaths_cases_all = death_global_df %>% 
  rename(region = `Country_Region`,
         sub_region = `Province_State`) %>% 
  group_by(region,date) %>%
  summarise(deaths = sum(death), .groups = 'drop')


# df for all confirmed, death, confirmed for all regions
df = confirmed_cases_all %>%
  left_join(recovered_cases_all) %>%
  left_join(deaths_cases_all) %>%
  group_by(region, date) %>%
  summarise(confirmed = sum(confirmed), death = sum(deaths), 
            recovered = sum(recovered), .groups = 'drop') %>%
  select(region, date, confirmed, death, recovered)
