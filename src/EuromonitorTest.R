# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# * EUROMONITOR TEST
# 
# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# *** PACKAGES *** ------------------------------------------------------------

# install.packages("PackageName")

install.packages("conflicted")

library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

library(dplyr) # Data manipulation/transformation

library(stringr) # Strings (text) manipulation

library(lubridate) # Parse, manipulate, and format dates and times

library(openxlsx) # Reading/writing/editing excel files

library(ggplot2) # Data visualization

library(tidyverse) # Data manipulation/transformation



# *** FILE 

# * Specify the file path
path <- "./data/market_data.xlsx"

# * mexico_market_size
mexico_market_size <- read.xlsx(path, sheet = "mexico_market_size")
print(colnames(mexico_market_size))
colnames(mexico_market_size) <- c(
  "Category", "Subcategory", "Data_Type", "Unit", "2016", "2017", "2018",
  "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026"
)

# * mexico_market_share
mexico_market_share <- read.xlsx(path, sheet = "mexico_market_share")
print(colnames(mexico_market_share))
colnames(mexico_market_share) <- c(
  "Subcategory", "Data_Type", "National_Brand_Owner", "Unit", "2016", "2017",
  "2018", "2019", "2020", "2021"
)

# * mexico_channel_breakdown
mexico_channel_breakdown <- read.xlsx(path, sheet = "mexico_channel_breakdown")
print(colnames(mexico_channel_breakdown))
colnames(mexico_channel_breakdown) <- c(
  "Category", "Subcategory", "Outlet", "Unit", "2016", "2017", "2018", "2019",
  "2020", "2021"
)

# * usa_market_size
usa_market_size <- read.xlsx(path, sheet = "usa_market_size")
print(colnames(usa_market_size))
colnames(usa_market_size) <- c(
  "Category", "Subcategory", "Data_Type", "Unit", "2016", "2017", "2018",
  "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026"
)

# * usa_market_share
usa_market_share <- read.xlsx(path, sheet = "usa_market_share")
print(colnames(usa_market_share))
colnames(usa_market_share) <- c(
  "Subcategory", "Data_Type", "National_Brand_Owner", "Unit", "2016", "2017",
  "2018", "2019", "2020", "2021"
)

# * usa_channel_breakdown
usa_channel_breakdown <- read.xlsx(path, sheet = "usa_channel_breakdown")
print(colnames(usa_channel_breakdown))
colnames(usa_channel_breakdown) <- c(
  "Category", "Subcategory", "Outlet", "Unit", "2016", "2017", "2018", "2019",
  "2020", "2021"
)

# * category_definitions
category_definitions <- read.xlsx(path, sheet = "category_definitions")
print(colnames(category_definitions))
colnames(category_definitions) <- c(
  "Industry", "Edition", "Category", "Hierarchy_level", "Definition"
)

# * channel_definitions
channel_definitions <- read.xlsx(path, sheet = "channel_definitions")
print(colnames(channel_definitions))
colnames(channel_definitions) <- c(
  "Industry", "Edition", "Outlet", "Hierarchy_level", "Definition"
)

# *** MARKET PERFORMANCE *** --------------------------------------------------



