# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# * EUROMONITOR TEST
# * https://github.com/VictorBenitoGR/EuromonitorTest
# * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# *** PACKAGES *** ------------------------------------------------------------

# install.packages("PackageName")

install.packages("conflicted") # Conflict management
library(conflicted) # Conflict management
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

library(dplyr) # Data manipulation/transformation

library(tidyr) # Data manipulation/transformation

library(stringr) # Strings (text) manipulation

library(lubridate) # Parse, manipulate, and format dates and times

library(openxlsx) # Reading/writing/editing excel files

library(ggplot2) # Data visualization

library(scales) # Scale functions for ggplot2

library(tidyverse) # Data manipulation/transformation

# *** FILE *** ----------------------------------------------------------------

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

# *** FILTER *** --------------------------------------------------------------

# * mexico_market_size
levels(factor(mexico_market_size$Data_Type))
mexico_market_size <- mexico_market_size[
  mexico_market_size$Data_Type == "Total Volume",
]
mexico_market_size$Country <- "Mexico"

# * usa_market_size
levels(factor(usa_market_size$Data_Type))
usa_market_size <- usa_market_size[
  usa_market_size$Data_Type == "Total Volume",
]
usa_market_size$Country <- "USA"

market_size <- rbind(mexico_market_size, usa_market_size)

# *** MARKET PERFORMANCE *** --------------------------------------------------

# * Reshape the data from wide to long format
market_size_long <- market_size %>%
  pivot_longer(
    cols = `2016`:`2026`,
    names_to = "Year", values_to = "Market_Size"
  )

# * Get the sum of every "Market_Size" for each year by country
market_size_summary <- market_size_long %>%
  group_by(Year, Country) %>%
  summarize(Total_Market_Size = sum(Market_Size))

# * Convert "Year" to numeric
market_size_summary$Year <- as.numeric(market_size_summary$Year)

# * Create a cuberoot transformation function (scales package)
cuberoot_trans <- trans_new(
  name = "cuberoot",
  transform = function(x) x^(1/3),
  inverse = function(x) x^3
)

# * Create a ggplot object
market_size_plot <- ggplot(market_size_summary, aes(
  x = Year, y = Total_Market_Size,
  color = Country
)) +
  geom_point(size = 5, alpha = 0.3) +
  geom_line(size = 1) +
  scale_y_continuous(trans = "log10") +
  facet_wrap(~Country, scales = "free") +
  theme_linedraw() +
  labs(title = "Total Market Size", x = NULL, y = "million litres") +
  theme(plot.title = element_text(face = "bold")) +
  scale_color_manual(values = c("Mexico" = "#b80000", "USA" = "#0000ca"))

# * Save the plot
ggsave("./assets/market_size_plot.jpg", market_size_plot,
  width = 10, height = 5
)

