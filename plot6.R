########################################################################
#
# This code reads the PM 2.5 data from the file "summaryscc_PM35.rds",
# plots the emission from motor vehicles for Baltimore (MA), from 1999
# to 2008, and outputs a file named "plot5.png" with a graphic showing
# the total emission per year from vehicles. It uses the data in the
# file "Source_Classification_Code.rds" in order to find out which
# emission comes from vehicles.
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
        SCC[grep("[Hh]ighway.*[Vv]ehicle", SCC$Short.Name), "SCC"]      # Creates a logical
                                                                        # vector where the
                                                                        # vehicle source is set
                                                                        # to TRUE.

NEIBaltimore <- NEI[SCCcodes & NEI$fips == "24510", c(4,6)]             # Gets vehicle data
                                                                        # from Baltimore.

png("plot5.png", width = 480, height = 480)                             # Opens PNG device.

totalEmissions <- (tapply(NEIBaltimore$Emissions,
                          NEIBaltimore$year, sum))                      # Calculates the total
                                                                        # emission per year.

par(cex.lab = 1.0, cex.main = 1.3, cex.sub = 0.8, pch = 19)             # Sets plot parameters.

plot(levels(NEIBaltimore$year), totalEmissions, type = "l", cex = 0.5,
     xlab = "year", ylab = "Emission (tons)",
     main = "Total Emission of PM 2.5 from Motor Vehicles\nBaltimore (MA), 1999- 2008.",
     sub = "Source: EPA NAtional Emissions Inventory")                  # Plots the line graphic.

points(levels(NEIBaltimore$year), totalEmissions, pch = 19, cex = 1.5)  # Plots bigger dots.

grid(NULL, NULL)                                                        # Plots the grid lines.
dev.off()                                                               # Close PNG device.
