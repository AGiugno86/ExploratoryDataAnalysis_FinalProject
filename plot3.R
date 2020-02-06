library("ggplot2")

# Unzip the two files if they do not exist
# Since the files are two, we set overwrite to FALSE in case we have to extract just one
if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) {
  zipFile <- "exdata_data_NEI_data.zip"
  unzip(zipfile = zipFile, overwrite = FALSE)
}

# Create the tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Compute totals
NEI$type <- as.factor(NEI$type)
NEI$year <- as.factor(NEI$year)
totalPM25 <- aggregate(Emissions ~ year + type, 
                       subset(NEI, fips == "24510"), 
                       sum)
names(totalPM25) <- c("year", "type", "TotalEmissions")

# Let's make the plot step by step

g <- ggplot(data = totalPM25, aes(year))
g <- g + geom_bar(aes(weight = TotalEmissions),
                  colour = "black",
                  fill = "red")
g <- g + facet_grid(rows = vars(type))
g <- g + labs(title = "Total amount of PM25 emissions per year and source type in Baltimore",
          x = "Years", y = "Total Emissions [tons]")
g <- g + theme(plot.margin = margin(1,1,1,1, "cm"))

# Save the plot to png
ggsave("plot3.png", plot=g, device = "png",
       height = 20, width = 20, units = "cm")

# All the sources except POINT have lowered their emissions over the years.
# Point sources have instead experienced an increase until 2005, followed by a sharp lowering.