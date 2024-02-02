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
  "Category", "Outlet", "Subcategory", "Unit", "2016", "2017", "2018", "2019",
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

# ! market_size
market_size <- rbind(mexico_market_size, usa_market_size)

# * mexico_channel_breakdown
levels(factor(mexico_channel_breakdown$Subcategory))
mexico_channel_breakdown <- mexico_channel_breakdown[
  mexico_channel_breakdown$Subcategory %in% c("Store-Based Retailing",
  "Non-Store Retailing", "On-trade"),
]
mexico_channel_breakdown$Country <- "Mexico"

# * usa_channel_breakdown
levels(factor(usa_channel_breakdown$Subcategory))
usa_channel_breakdown <- usa_channel_breakdown[
  usa_channel_breakdown$Subcategory %in% c("Store-Based Retailing",
  "Non-Store Retailing", "On-trade"),
]
usa_channel_breakdown$Country <- "USA"

# ! trends
trends <- rbind(mexico_channel_breakdown, usa_channel_breakdown)

# * mexico_market_share
# Delete the last row of mexico_market_share
mexico_market_share <- mexico_market_share[-nrow(mexico_market_share), ]
mexico_market_share$Country <- "Mexico"
# Replace "-" with "0" in mexico_market_share
mexico_market_share[mexico_market_share == "-"] <- "0"

# * usa_market_share
# Delete the last row of usa_market_share
usa_market_share <- usa_market_share[-nrow(usa_market_share), ]
usa_market_share$Country <- "USA"
# Replace "-" with "0" in usa_market_share
usa_market_share[usa_market_share == "-"] <- "0"

# ! market_share
market_share <- rbind(mexico_market_share, usa_market_share)

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
  x = Year, y = Total_Market_Size, color = Country
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

# *** TRENDS *** --------------------------------------------------------------

# * Reshape the data from wide to long format
trends_long <- trends %>%
  pivot_longer(
    cols = `2016`:`2021`,
    names_to = "Year", values_to = "Trend"
  )
trends <- trends_long

trends$Trend <- as.numeric(trends$Trend)

# Create a ggplot object
trends_plot <- ggplot(trends, aes(
  x = Year, y = Trend, fill = Subcategory
)) +
  geom_bar(stat = "identity", position = "fill") + # Stack the bars
  facet_wrap(~Country, scales = "free") +
  labs(title = "Trends (%)", x = NULL, y = "million litres") +
  theme(plot.title = element_text(face = "bold")) +
  theme_linedraw()

# Save the plot
ggsave("./assets/trends_plot.jpg", trends_plot,
  width = 10, height = 5
)


# *** FUTURE OUTLOOK *** ------------------------------------------------------

future_outlook <- market_size_long %>%
  select(Subcategory, Country, Year, Market_Size)

# ? Today's February 2, 2024
future_outlook <- future_outlook %>%
  filter(Year %in% c(2024, 2025, 2026))

future_outlook_summary <- future_outlook %>%
  group_by(Year, Subcategory, Country) %>%
  summarize(Total_Market_Size = sum(Market_Size))

# Create plot
future_outlook_plot <- ggplot(future_outlook_summary, aes(x = Year, y = Total_Market_Size, fill = Subcategory)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~Country, scales = "free") +
  labs(title = "Future Outlook (2024 - 2026)", x = NULL, y = "Total Market Size") +
  theme(plot.title = element_text(face = "bold")) +
  scale_y_log10() +
  theme_linedraw()

# Save the plot
ggsave("./assets/future_outlook_plot.jpg", future_outlook_plot, width = 10, height = 5)


# *** COMPETITIVE ENVIRONMENT *** ---------------------------------------------
# * Reshape the data from wide to long format
market_share_long <- market_share %>%
  pivot_longer(
    cols = `2016`:`2021`,
    names_to = "Year", values_to = "Market_Share"
  )

market_share_long$Year <- as.numeric(market_share_long$Year)
market_share_long$Market_Share <- as.numeric(market_share_long$Market_Share)

market_share_summary <- market_share_long %>%
  group_by(National_Brand_Owner, Country) %>%
  summarize(Average_Market_Share = mean(Market_Share))
install.packages("viridis")
library(viridis)
# Create pie chart
market_share_plot <- ggplot(market_share_summary, aes(x = "", y = Average_Market_Share, fill = National_Brand_Owner)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  facet_wrap(~Country) +
  labs(title = "Market Share by National Brand Owner", x = NULL, y = NULL) +
  theme(plot.title = element_text(face = "bold")) +
  scale_fill_viridis_d(option = "turbo", direction = 1) +
  theme_linedraw()

# Save the pie chart
ggsave("./assets/market_share_plot.jpg", market_share_plot, width = 10, height = 5)
