# Unzip the two files if they do not exist
# Since the files are two, we set overwrite to FALSE in case we have to extract just one
if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) {
  zipFile <- "exdata_data_NEI_data.zip"
  unzip(zipfile = zipFile, overwrite = FALSE)
}

# Create the tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
relevant_source <- as.character(SCC[vehicles, "SCC"])
Baltimore <- subset(NEI, fips == "24510")
relevantBaltNEI <- Baltimore[Baltimore$SCC %in% c(relevant_source),]

# Compute the total emissions and plot

totalPM25 <- aggregate(Emissions ~ year, relevantBaltNEI, sum)
names(totalPM25) <- c("year", "TotalEmissions")

# Make the plot
png("plot5.png", height = 480, width = 480, units = "px")
barplot(totalPM25$TotalEmissions,
        main = "Total amount of PM2.5 emissions from motor vehicles in Baltimore",
        xlab = "Years", ylab = "Total PM2.5 emissions [kTons]",
        col = "red",
        names.arg = row.names(totalPM25$year))
dev.off()

#Emissions plummeted heavily between 2002 and 1999, while decreasing more mildly afterwards