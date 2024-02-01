# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# * EUROMONITOR
# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# *** PACKAGES *** ------------------------------------------------------------

# install.packages("PackageName")

library(dplyr) # Data manipulation/transformation

library(stringr) # Strings (text) manipulation

library(lubridate) # Parse, manipulate, and format dates and times

library(openxlsx) # Reading/writing/editing excel files

# *** FILE *** ----------------------------------------------------------------

getwd() # Change Working Directory with setwd("/path/to/DataCleaner") if needed

dataset <- read.xlsx("2022 PowerPoint Test - Market Data.xlsx")
