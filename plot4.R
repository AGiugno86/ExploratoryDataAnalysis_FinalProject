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

# Check the presence of coal combustion related sources
# and subset NEI accordingly

combustion <- grepl("comb", SCC$SCC.Level.One, ignore.case = TRUE)
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case = TRUE)
relevant_sources <- as.character(SCC[combustion & coal, "SCC"])
relevantNEI <- NEI[NEI$SCC %in% c(relevant_sources),]

# Compute the total emissions and plot

totalPM25 <- aggregate(Emissions ~ year, relevantNEI, sum)
names(totalPM25) <- c("year", "TotalEmissions")

# Make the plot
png("plot4.png", height = 600, width = 660, units = "px")
barplot(totalPM25$TotalEmissions/10^6,
        main = "Total amount of PM2.5 emissions from coal combustion-related sources in the US",
        xlab = "Years", ylab = "Total PM2.5 emissions [kTons]",
        col = "red",
        names.arg = row.names(totalPM25$year))
dev.off()

#Yes, the total amount of that kind of emissions has steadily decreased.