########################################################################
#
# This code reads the PM 2.5 data from the file "summaryscc_PM35.rds",
# plots the emission from any coal source for the entire US, from 1999
# to 2008, and outputs a file named "plot4.png" showing a graphic with
# the total emission per year from coal. It uses the data in the file
# "Source_Classification_Code.rds" in order to find out which emission
# comes from coal.
#
# The code file must be placed in the same folder of the data files.
# The PNG file is saved in the same folder.
#
# (c) Daniel Kinpara, 2015.
#
########################################################################

NEI <- readRDS("summarySCC_PM25.rds")                                   # Reads the data file.
SCC <- readRDS("Source_Classification_Code.rds")                        # Reads the SCC file.

NEI <- transform(NEI, year = factor(year))                              # Transforms year into
                                                                        # a factor.

SCCcodes <- NEI$SCC %in%
        SCC[grep("Comb.*Coal", SCC$Short.Name), "SCC"]                  # Creates a logical
                                                                        # vector where the
                                                                        # coal source is set
                                                                        # to TRUE.

NEIcoal <- NEI[SCCcodes, c(4,6)]                                        # Gets coal data.

png("plot4.png", width = 480, height = 480)                             # Opens PNG device.

totalEmissions <- (tapply(NEIcoal$Emissions, NEIcoal$year, sum)) / 1e+3 # Calculates the total
                                                                        # emission per year
                                                                        # and adjusts the
                                                                        # results to thousand
                                                                        # of tons.

par(cex.lab = 1.0, cex.main = 1.3, cex.sub = 0.8, pch = 19)             # Sets plot parameters.

plot(levels(NEIcoal$year), totalEmissions, type = "l", cex = 0.5,
     xlab = "year", ylab = "Emission (thousand tons)",
     main = "Total Emission of PM 2.5 from Coal\nUnited States, 1999- 2008.",
     sub = "Source: EPA NAtional Emissions Inventory")                  # Plots the line graphic.

points(levels(NEI$year), totalEmissions, pch = 19, cex = 1.5)           # Plots bigger dots.

grid(NULL, NULL)                                                        # Plots the grid lines.
dev.off()                                                               # Close PNG device.
