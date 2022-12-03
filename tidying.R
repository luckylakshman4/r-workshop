
# Tidying

# Reshaping data frames (converting from long-to-wide, or wide-to-long format), 
# separating and uniting variable (column) contents, and finding and replacing string patterns

# Use tidyr::pivot_wider() and tidyr::pivot_longer() to reshape data frames
# janitor::clean_names() to make column headers more manageable
# tidyr::unite() and tidyr::separate() to merge or separate information from different columns
# Detect or replace a string with stringr functions

# install packages
# install.packages("tidyverse")
# install.packages("janitor")
# install.packages("here")
# install.packages("readxl")


# Attach packages
library(tidyverse)
library(janitor)
library(here)
library(readxl)

# Use read_excel() to read in the inverts.xlsx data as an objected called inverts.

inverts <- read_excel(here("data", "inverts.xlsx"))

# explore the imported data
View(inverts)
names(inverts)
summary(inverts)

# tidyr::pivot_longer() to reshape from wider-to-longer format
# works like unpivoting

# use tidyr::pivot_longer() to gather data from all years in inverts (columns 2016, 2017, and 2018) into two columns:
  
# one called year, which contains the year
# one called sp_count containing the number of each species observed.

# The new data frame will be stored as inverts_long


# Note: Either single-quotes, double-quotes, OR backticks around years work!

inverts_long <- pivot_longer(data = inverts, 
                             cols = '2016':'2018',
                             names_to = "year",
                             values_to = "sp_count")
inverts_long

class(inverts_long$year) #Explore the class of year

# create a new column (use mutate() ) that has the same name of an existing column, in order to update and overwrite the existing column.

# add a column called year, which contains an as.numeric() version of the existing year variable

# Coerce "year" class to numeric: 
inverts_long <- inverts_long %>% 
  mutate(year = as.numeric(year))

class(inverts_long$year) # check class


# tidyr::pivot_wider() to convert from longer-to-wider format
# works like pivot

inverts_wide <- inverts_long %>% 
  pivot_wider(names_from = common_name, 
              values_from = sp_count)
inverts_wide


# janitor::clean_names() to clean up column names

# The janitor package by Sam Firke is a great collection of functions for some quick data cleaning, like:
  
# janitor::clean_names(): update column headers to a case of your choosing
# janitor::get_dupes(): see all rows that are duplicates within variables you choose
# janitor::remove_empty(): remove empty rows and/or columns
# janitor::adorn_*(): jazz up tables

# Here, we’ll use janitor::clean_names() to convert all of our column headers to a more convenient case - the default is lower_snake_case, which means all spaces and symbols are replaced with an underscore (or a word describing the symbol), all characters are lowercase, and a few other nice adjustments.

# My...RECENT-income! becomes my_recent_income
# SAMPLE2.!test1 becomes sample2_test1
# ThisIsTheName becomes this_is_the_name
# 2015 becomes x2015

inverts_wide <- inverts_wide %>% 
  clean_names()
names(inverts_wide)


# tidyr::unite() and tidyr::separate() to combine or separate information in column(s)

# tidyr::unite() to merge information from separate columns


# We need to give tidyr::unite() several arguments:

# data: the data frame containing columns we want to combine (or pipe into the function from the data frame)
# col: the name of the new “united” column
# the columns you are uniting
# sep: the symbol, value or character to put between the united information from each column

inverts_unite <- inverts_long %>% 
  unite(col = "site_year", # What to name the new united column
        c(site, year), # The columns we'll unite (site, year)
        sep = "_") # How to separate the things we're uniting
inverts_unite


#Create a new object called ‘inverts_moyr,’ starting from inverts_long, that unites the month and year columns into a single column named “mo_yr,” using a slash “/” as the separator.

inverts_moyr <- inverts_long %>% 
  unite(col = "mo_yr", # What to name the new united column
        c(month, year), # The columns we'll unite (site, year)
        sep = "/") 
inverts_moyr


# Uniting more than 2 columns: 

inverts_triple_unite <- inverts_long %>% 
  tidyr::unite(col = "year_site_name",
               c(year, site, common_name),
               sep = "-") # Note: this is a dash
inverts_triple_unite


# tidyr::separate() to separate information into multiple columns

inverts_sep <- inverts_unite %>% 
  tidyr::separate(site_year, into = c("my_site", "my_year"))
inverts_sep


# stringr::str_replace() to replace a pattern

ca_abbr <- inverts %>% 
  mutate(
    common_name = 
      str_replace(common_name, 
                  pattern = "california", 
                  replacement = "CA")
  )
ca_abbr
