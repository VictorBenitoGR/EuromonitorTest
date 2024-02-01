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
