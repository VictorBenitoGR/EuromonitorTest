# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# * EUROMONITOR TEST
# 
# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# *** PACKAGES *** ------------------------------------------------------------

# install.packages("PackageName")

library(dplyr) # Data manipulation/transformation

library(stringr) # Strings (text) manipulation

library(lubridate) # Parse, manipulate, and format dates and times

library(openxlsx) # Reading/writing/editing excel files

library(ggplot2) # Data visualization

library(tidyverse) # Data manipulation/transformation

# *** FILE *** ----------------------------------------------------------------

# Specify the file path
file_path <- "./data/market_data.xlsx"

# Read each sheet into a separate data frame
mexico_market_size <- read.xlsx(file_path, sheet = "mexico_market_size")
mexico_market_share <- read.xlsx(file_path, sheet = "mexico_market_share")
mexico_channel_breakdown <- read.xlsx(file_path,
  sheet = "mexico_channel_breakdown"
)
usa_market_size <- read.xlsx(file_path, sheet = "usa_market_size")
usa_market_share <- read.xlsx(file_path, sheet = "usa_market_share")
usa_channel_breakdown <- read.xlsx(file_path, sheet = "usa_channel_breakdown")
category_definitions <- read.xlsx(file_path, sheet = "category_definitions")
channel_definitions <- read.xlsx(file_path, sheet = "channel_definitions")

# *** MARKET PERFORMANCE *** --------------------------------------------------

# Combine data frames for Mexico and the US
combined_market_size <- rbind(mexico_market_size, usa_market_size)

# Melt the data frame to long format for easy plotting
melted_data <- reshape2::melt(combined_market_size, id.vars = c("Category", "Subcategory", "Data Type", "Unit"))

# Plotting
ggplot(melted_data, aes(x = variable, y = value, fill = Category)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  facet_wrap(~Country, scales = "free_y") +
  labs(title = "Market Performance Comparison: Mexico vs. USA",
       x = "Year",
       y = "Market Size",
       fill = "Category") +
  theme_minimal()