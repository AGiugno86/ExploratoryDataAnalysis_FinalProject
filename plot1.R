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
totalPM25 <- aggregate(Emissions ~ year, NEI, sum)
names(totalPM25) <- c("year", "TotalEmissions")

# Make the plot
png("plot1.png", height = 480, width = 480, units = "px")
barplot(totalPM25$TotalEmissions,
        main = "Total amount of emissions in the observed years",
        xlab = "Years", ylab = "Total PM25 emissions",
        col = "red",
        names.arg = row.names(totalPM25$year))
dev.off()

#Yes, the total amount of emissions has steadily decreased.