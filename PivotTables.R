
#-------- Pivot Tables with dplyr -------------------------------

# create these tables using the group_by and summarize functions from the dplyr package (part of the Tidyverse)

## attach libraries
library(tidyverse)
library(readxl)
library(here)
library(skimr) # install.packages('skimr')
library(kableExtra) # install.packages('kableExtra')

## read in data
lobsters <- read_xlsx(here("data/lobsters2.xlsx"), skip=4)

# head(lobsters) # for top 6 rows

# explore data
skimr::skim(lobsters) # skim lets us look more at each variable

# group_by() %>% summarize()
# In R, we can create the functionality of pivot tables with the same logic: 
# we will tell R to group by something and then summarize by something


# Take the data and then group by something and then summarize by something
# Syntax
# data %>%
#   group_by() %>% 
#   summarize()

# The pipe operator %>% is a really critical feature of the dplyr package, originally created for the magrittr package. 
# It lets us chain together steps of our data wrangling, enabling us to tell a clear story about our entire data analysis.


# group_by one variable

# group_by() %>% summarize() with our lobsters data, just like we did in Excel. 
# We will first group_by year and then summarize by count, using the function n() (in the dplyr package). 
# n() counts the number of times an observation shows up, and since this is uncounted data, this will count each row.

lobsters %>%
group_by(year) %>%
  summarise(count_by_year=n())


# group_by multiple variables

lobsters %>%
  group_by(site, year) %>%
  summarise(count_by_siteyear=n())

# summarize multiple variables

lobsters %>%
  group_by(site, year) %>%
  summarize(count_by_siteyear =  n(),
            mean_size_mm = mean(size_mm)) # by count and mean

# NA because one or more values in that year are NA. 
# pass an argument   na.rm=TRUE   that says to remove NAs first before calculating the average. 
# Then Calculate the standard deviation with the sd() function

lobsters %>%
  group_by(site, year) %>%
  summarize(count_by_siteyear =  n(), 
            mean_size_mm = mean(size_mm, na.rm=TRUE), #na.rm to remove NA
            sd_size_mm = sd(size_mm, na.rm=TRUE)) #summarise by count, mean, sd


# save this summary information as a variable so we can use it in further analyses and formatting

siteyear_summary <- lobsters %>%
  group_by(site, year) %>%
  summarize(count_by_siteyear =  n(), 
            mean_size_mm = mean(size_mm, na.rm=TRUE), #na.rm to remove NA
            sd_size_mm = sd(size_mm, na.rm=TRUE)) #summarise by count, mean, sd


siteyear_summary #inspect our new variable


# Table formatting with kable()

# make a table with our new variable
siteyear_summary %>%
  kable()


# add median
siteyear_summary <- lobsters %>%
  group_by(site, year) %>%
  summarize(count_by_siteyear =  n(), 
            mean_size_mm = mean(size_mm, na.rm = TRUE), 
            sd_size_mm = sd(size_mm, na.rm = TRUE), 
            median_size_mm = median(size_mm, na.rm = TRUE))

siteyear_summary

# a ggplot option:
ggplot(data = siteyear_summary, aes(x = year, y = median_size_mm, color = site)) +
  geom_line() +
  theme_minimal()
ggsave(here("figures", "lobsters-line.png")) # save image


## another option:
ggplot(siteyear_summary, aes(x = year, y = median_size_mm, fill = site, color =site)) +
  geom_col() +
  facet_wrap(~site)
ggsave(here("figures", "lobsters-col.png"))

# Oh no, they sent the wrong data!
#lobsters2.xlsxis latest file, not lobsters.xlsx. Aaaaah!

## read in data or update file name in the initial step, that's it
# lobsters <- read_xlsx(here("data/lobsters2.xlsx"), skip=4)


#dplyr::count()
#Now that we’ve spent time with group_by %>% summarize, there is a shortcut if you only want to summarize by count. 
#This is with a function called count(), and it will group_by your selected variable, count, and then also ungroup.

lobsters %>%
  count(site, year)

## This is the same as:
lobsters %>%
  group_by(site, year) %>% 
  summarize(n = n()) %>%
  ungroup()

View(lobsters)


# Make new variable with mutate()

# The sizes are in millimeters but let’s say it was important for them to be in meters. 
# We can add a column with this calculation

lobsters %>%
  mutate(size_m = size_mm / 1000)

# If we want to add a column that has the same value repeated, 
# we can pass it just one value, either a number or a character string (in quotes). 
# And let’s save this as a variable called lobsters_detailed

lobsters_detailed <- lobsters %>%
  mutate(size_m = size_mm / 1000, 
         millenia = 2000,
         observer = "Allison Horst")
lobsters_detailed


# select()

# to choose, retain, and move your data by columns

# to present this data finally with only columns for date, site, and size in meters

lobsters_detailed %>%
  select(date, site, size_m)


















