

# Clean-up packages
rm(list = ls(all.names = TRUE))

#Load libraries
library(dplyr)
library(ggplot2)
library(tidyverse)
library(LexisPlotR)


#Load data from the Wittgenstein Centre Data Explorer package
library(wcde)

# Import data on population size by age and sex for the United Arab Emirates 
# (SSP2 medium scenario) into R using the wcde package.
# Use the vignette to get code for finding the World Populations - 
# under "Working with population data" section for a "range of 
# age-sex-educational attainment combinations" - Understand the data better
  vignette("wcde")
# This list shows all indicators related to "pop". 
# For age and sex as the correct indicator (#18, Population Size (000's))
  print(find_indicator(x = "pop") %>% 
          select(indicator, description), n = 25)  # pulls data for 2020 & 2025
# pulls data before 2020 (viz. for 2015)
  print(find_indicator(x = "pop"), version = "wcde-v2") 
# Assign the "bpop" indicator to a variable, filtering only for UAE and for 
# the 'projections' from 2020 and 2025 (5 yr increments)
# The description for this indicator is "Population Size by Broad Age (000's)", 
# which contains both age interval and sex columns
  uae_pop <- get_wcde(indicator = "bpop", 
                      version = "wcde-v2", 
                      country_name = "United Arab Emirates")
      
# Calculate the sex ratio for the working-age population for 2025, defined as:
# (Male working-age population (20-64) / Female working-age population (20-64))
# Then filter the uae_pop variable to the working age population for 2025:
  uae_pop_wa <- uae_pop %>% filter(year == 2025, age %in% c("20--39","40--64"))

# Create a variable of the working age population for males and females:
  uae_pop_wa_m <- uae_pop_wa %>% filter(sex == "Male")
  uae_pop_wa_f <- uae_pop_wa %>% filter(sex == "Female")

# Divide the cumulative sum of the pop column for each sex,  
# then divide male pop by female pop
  cat("The sex-ratio for the working-age population of the UAE in 2025 is", 
      round(sum(uae_pop_wa_m$bpop) / sum(uae_pop_wa_f$bpop), 2))


# Use the "LexisPlotR" package to plot a lexis diagram for the years 2015-2025 
# for age 20-30. For practice, I will add a lifeline to include my false DoB,
# when I began my second masters studies, and my intended graduation date
  
# Create the base of the Lexis grid for the years 2015-2030 and ages 20-35 (I expanded the range to include my lifeline ;])
  uae_lexis <- lexis_grid( year_start = 2015,
                         year_end = 2030,
                         age_start = 20, 
                         age_end = 35)
  

# Add the lifeline for my DoB, Uni entry, and planned graduation date
  lexis_lifeline(lg = uae_lexis,
                 birth = "1990-03-01" , 
                 entry = "2024-10-01",
                 exit = "2026-06-30", 
                 lineends = T, col=10, lwd=1.0)