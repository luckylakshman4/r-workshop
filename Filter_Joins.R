
# filter() to conditionally subset our data by rows, and
# *_join() functions to merge data frames together
# And we’ll make a nicely formatted HTML table with kable() and kableExtra

# Use filter() to subset data frames, returning rows that satisfy variable conditions
# Use full_join(), left_join(), and inner_join() to merge data frames, with different endpoints in mind
# Use filter() and *_join() as part of a wrangling sequence


library(tidyverse)
library(readxl)
library(here) 
library(kableExtra)

# Read in data: 
fish <- read_csv(here("data", "fish.csv"))
kelp_abur <- read_excel(here("data", "kelp.xlsx"), sheet = "abur") # to read data from particular sheet

# View(fish)
# View(kelp_abur)

# dplyr::filter() to conditionally subset by rows

# Filter rows by matching a single character string

# Use == to ask R to look for exact matches:
  
fish_garibaldi <- fish %>% 
filter(common_name == "garibaldi")
fish_garibaldi

fish_mohk <- fish %>% 
  filter(site == "mohk")
fish_mohk


# Filter rows based on numeric conditions

# retain observations when the total_count column value is >= 50

fish_over50 <- fish %>% 
  filter(total_count >= 50)
fish_over50


# Filter to return rows that match this OR that OR that

fish_3sp <- fish %>% 
  filter(common_name == "garibaldi" | 
           common_name == "blacksmith" | 
           common_name == "black surfperch")
fish_3sp


# Alternate

fish_3sp <- fish %>% 
  filter(common_name %in% c("garibaldi", "blacksmith", "black surfperch"))
fish_3sp


fish_gar_2016 <- fish %>% 
  filter(year == 2016 | common_name == "garibaldi")


# Filter to return observations that match this AND that

aque_2018 <- fish %>% 
  filter(year == 2018, site == "aque")
aque_2018


# Use the ampersand (&) to add another condition "and this must be true":
aque_2018 <- fish %>% 
  filter(year == 2018 & site == "aque")

# Written as sequential filter steps:
aque_2018 <- fish %>% 
  filter(year == 2018) %>% 
  filter(site == "aque")

low_gb_wr <- fish %>% 
  filter(common_name %in% c("garibaldi", "rock wrasse"), 
         total_count <= 10)
low_gb_wr



# stringr::str_detect() to filter by a partial pattern

# we’ll use stringr::str_detect() to find and keep observations that contain our specified string pattern.

fish_bl <- fish %>% 
  filter(str_detect(common_name, pattern = "black"))
fish_bl
# str_detect() returns is a series of TRUE/FALSE responses for each row


fish_it <- fish %>% 
  filter(str_detect(common_name, pattern = "it"))
# blacksmITh and senorITa remain!

# We can also exclude observations that contain a set string pattern by adding the negate = TRUE argument within str_detect()

fish_it <- fish %>% 
  filter(str_detect(common_name, pattern = "it", negate = TRUE))
fish_it


# dplyr::*_join() to merge data frames

## full_join() to merge data frames, keeping everything

abur_kelp_fish <- kelp_abur %>% 
  full_join(fish, by = c("year", "site")) 
kelp_abur
abur_kelp_fish

## left_join(x,y) to merge data frames, keeping everything in the ‘x’ data frame and only matches from the ‘y’ data frame

kelp_fish_left <- kelp_abur %>% 
  left_join(fish, by = c("year","site"))
kelp_fish_left

# inner_join() to merge data frames, only keeping observations with a match in both

kelp_fish_injoin <- kelp_abur %>% 
  inner_join(fish, by = c("year", "site"))
kelp_fish_injoin # kelp_fish_injoin


# filter() and join() in a sequence

# Start with fish data frame
# Filter fish to only including observations for 2017 at Arroyo Burro
# Join the kelp_abur data frame to the resulting subset using left_join()
# Add a new column that contains the ‘fish per kelp fronds’ density (total_count / total_fronds)

my_fish_join <- fish %>% 
  filter(year == 2017, site == "abur") %>% 
  left_join(kelp_abur, by = c("year", "site")) %>% 
  mutate(fish_per_frond = total_count / total_fronds)
my_fish_join

























