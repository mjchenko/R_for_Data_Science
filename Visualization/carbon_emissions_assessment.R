library(tidyverse)
library(dslabs)
data(temp_carbon)
data(greenhouse_gases)
data(historic_co2)

# temp_carbon %>% .$year %>% max()

temp_carbon %>% filter(!is.na(carbon_emissions)) %>% pull(year) %>% max()

# temp_carbon %>% filter(!is.na(carbon_emissions)) %>% max(year)

temp_carbon %>% filter(!is.na(carbon_emissions)) %>% .$year %>% max()

temp_carbon %>% filter(!is.na(carbon_emissions)) %>% select(year) %>% max()


temp_carbon %>% filter(!is.na(carbon_emissions)) %>% 
  select(year) %>% summarize(max_year = max(year), min_year = min(year))

temp_carbon %>% filter(!is.na(carbon_emissions), year %in% c(1751, 2014)) %>% 
  select(year, carbon_emissions) %>% summarize(mult=max(carbon_emissions)/min(carbon_emissions))

temp_carbon %>% filter(!is.na(temp_anomaly)) %>% 
  select(year, temp_anomaly) %>% summarize(max_year = max(year), min_year = min(year))

temp_carbon %>% filter(!is.na(temp_anomaly), year %in% c(1880, 2018)) %>% 
  select(year, temp_anomaly) %>% summarize(diff = max(temp_anomaly) - min(temp_anomaly))

p <- temp_carbon %>% filter(!is.na(temp_anomaly)) %>% 
  ggplot(aes(x = year, y = temp_anomaly)) + geom_line(color = "black")
p <- p + geom_hline(aes(yintercept = 0), color = "red") + 
  ylab("Temperature anomaly (degrees C)") +
  ggtitle("Temperature Anomaly Relative to 20th Century Mean, 1880-2018") + 
  geom_text(aes(x = 2000, y = 0.05, label = "20th Century Mean"), col = "red") +
  geom_line(aes(x = year, y = land_anomaly), color = "green") + 
  geom_line(aes(x = year, y = ocean_anomaly), color = "blue") +
  geom_text(aes(x = 2000, y = 1.1, label = "Land"), color = "green") +
  geom_text(aes(x = 1875, y = -0.2, label = "Global"), color = "black") +
  geom_text(aes(x = 2020 , y = 0.4, label = "Ocean"), color = "blue")
p






greenhouse_gases %>%
  ggplot(aes(x = year, y = concentration)) +
  geom_line() +
  facet_grid(gas~., scales = "free") +
  geom_vline(xintercept = 1850) +
  ylab("Concentration (ch4/n2o ppb, co2 ppm)") +
  ggtitle("Atmospheric greenhouse gas concentration by year, 0-2000")


#While many aspects of climate are independent of human influence, and co2 
#levels can change without human intervention, climate models cannot reconstruct 
#current conditions without incorporating the effect of manmade carbon emissions. 
#These emissions consist of greenhouse gases and are mainly the result of burning 
#fossil fuels such as oil, coal and natural gas.

#Make a time series line plot of carbon emissions (carbon_emissions) from the 
#temp_carbon dataset. The y-axis is metric tons of carbon emitted per year
temp_carbon %>% filter(!is.na(carbon_emissions)) %>% 
  ggplot(aes(x = year, y = carbon_emissions)) + geom_line(color = "black")



co2_time <- historic_co2 %>% filter(!is.na(co2)) %>% 
  ggplot(aes(x = year, y = co2, color = source)) + geom_line() 
co2_time + xlim(-800000, -775000)
co2_time + xlim(-375000, -330000)
co2_time + xlim(-140000, -120000)
co2_time + xlim(-3000, 2018)