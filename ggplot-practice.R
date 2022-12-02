# Plots with ggplot2


library(tidyverse)
library(readxl)
library(here)

# use read_csv() to read in the file
# use here() within read_csv() to tell it where to look
# assign the stored data an object name (we’ll store ours as ca_np)

ca_np <- read_csv(here("data", "ca_np.csv")) #to read csv file
# View(ca_np) to view data in separator viewing tab

# explore our data frame a bit more to see what it contains.
  
names(ca_np) # to see the variable (column) names
head(ca_np) # to see the first x rows (6 is the default)
summary(ca_np) # see a quick summary of each variable


#Use read_excel() to get the ci_np.xlsx data into R:
  
ci_np <- read_excel(here("data", "ci_np.xlsx"))
view(ci_np)

names(ci_np) # to see the variable (column) names
head(ci_np) # to see the first x rows (6 is the default)
summary(ci_np) # see a quick summary of each variable


# Our first ggplot graph: Visitors to Channel Islands NP

# Generally, that structure will look like this:
 
# ggplot(data = df_name, aes(x = x_var_name, y = y_var_name)) + geom_type()

# Breaking that down:

# First, tell R you’re using ggplot()
# Then, tell it the object name where variables exist (data = df_name)
# Next, tell it the aesthetics aes() to specify which variables you want to plot
# Then add a layer for the type of geom (graph type) with geom_*() - 
# for example, geom_point() is a scatterplot, geom_line() is a line graph, geom_col() is a column graph, etc.
# Let’s do that to create a line graph of visitors to Channel Islands National Park:

ggplot(data = ci_np, aes(x = year, y = visitors)) +
  geom_line()

ggplot(data = ci_np, aes(x = year, y = visitors)) +
  geom_point()


# We’re going to be doing a lot of plot variations with those same variables. 
#Let’s store the first line as object gg_base so that we don’t need to retype it each time
  
gg_base <- ggplot(data = ci_np, aes(x = year, y = visitors)) # creating base
  
# we could change that to a scatterplot just by updating the geom_*:
gg_base + geom_point()
gg_base + geom_line()
gg_base + geom_col()
gg_base + geom_area()

# customizing ggplot graphs

# Some common arguments we’ll use first are:

#  color = or colour =: update point or line colors
# fill =: update fill color for objects with areas
# linetype =: update the line type (dashed, long dash, etc.)
# pch =: update the point style
# size =: update the element size (e.g. of points or line thickness)
# alpha =: update element opacity (1 = opaque, 0 = transparent)

gg_base +
  geom_line(
    color = "purple",
    linetype = "dashed"
  ) # changed color to purple, linetype to dashed

gg_base +   geom_point(color = "purple",
             pch = 18,
             size = 3,
             alpha = 0.75)

#-------- customize your own ggplot graph

# Mapping variables onto aesthetics

# When we want to customize a graph element based on a variable’s characteristic or value, 
# add the argument within aes() in the appropriate geom_*() layer

# scatterplot graph where the size and color of the points change based on the number of visitors


gg_base + geom_point(
  aes( size = visitors, color = visitors),
  alpha = 0.5 
) # size and colour based on no. of visitors

gg_base + 
  geom_col(aes(fill = visitors))

<<<<<<< HEAD
# ggplot2 complete themes
# built-in themes (theme_*()) that you can add to your ggplot code to make some major headway before making smaller tweaks manually

# theme_light()
# theme_minimal()
# theme_bw()

gg_base +
  geom_point(
    aes(size = visitors,
        color = visitors),
    alpha = 0.5
  ) +
  theme_minimal() # changed the theme


# Updating axis labels and titles
# Use labs() to update axis labels, and add a title and/or subtitle to your ggplot graph

gg_base +
  geom_line(linetype = "dotted") +
  theme_bw() +
  labs(
    x = "Year",
    y = "Annual park visitors",
    title = "Channel Islands NP Visitation",
    subtitle = "(1963 - 2016)"
  ) # updating labels and title

# Combining compatible geoms

gg_base +
  geom_line(color = "purple") +
  geom_point(color = "orange",
             aes(size = year),
             alpha = 0.5) # combining graphs


gg_base +
  geom_line(color = "purple") +
  geom_point(color = "orange",
             aes(size = year),
             alpha = 0.5) +
  theme_bw() +
  labs(
    x = "Year",
    y = "Annual park visitors",
    title = "Channel Islands NP Visitation",
    subtitle = "(1963 - 2016)"
  )


gg_base +
  geom_col(fill = "orange",
           color = "purple") +
  geom_line(color = "green")


#Multi-series ggplot graphs 

ggplot(data = ca_np, aes(x = year, y = visitors)) +
  geom_line() 


ggplot(data = ca_np, aes(x = year, y = visitors, group = park_name)) +
  geom_line() #splitting based on other variable

ggplot(data = ca_np, aes(x = year, y = visitors, group = park_name, color = park_name)) +
  geom_line() #splitting based on other variable


gg_np <- ggplot(data = ca_np, aes(x = year, y = visitors, group = park_name, color = park_name))
gg_np <- ggplot(data = ca_np, aes(x = year, y = visitors, group = park_name))

#  Faceting ggplot graphs --- splitting graphs

gg_np +
  geom_line(show.legend = FALSE) +
  theme_light() + 
  labs(x = "year", y = "annual visitors") +
  facet_wrap(~ park_name) #split based on park name


# Exporting a ggplot graph with ggsave()

#ggsave() will export the most recently run ggplot graph by default (plot = last_plot()), unless you give it the name of a different saved ggplot object. Some common arguments for ggsave():
  
# width =: set exported image width (default inches)
# height =: set exported image height (default height)
# dpi =: set dpi (dots per inch)

ggsave(here("figures", "np_graph.jpg"), dpi = 180, width = 8, height = 7)




=======
>>>>>>> 621df973e8bf58c8b9c2b30af899e152bd3ee52a


















