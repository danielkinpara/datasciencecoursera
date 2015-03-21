########################################################################
#
# This code reads the PM 2.5 data from the file "summaryscc_PM35.rds",
# calculates the total emissions in Baltimore (MA), from 1999 to 2008,
# and outputs a file named "plot2.png" containing a graphic of the
# total emissions.
#
# The code file must be placed in the same folder of the data file.
# The PNG file is saved in the same folder.
#
# (c) Daniel Kinpara, 2015.
#
########################################################################


NEI <- readRDS("summarySCC_PM25.rds")                                   # Reads the data file.

NEI <- transform(NEI, year = factor(year))                              # Transforms the variable
                                                                        # "year" into a factor

NEIBaltimore <- NEI[NEI$fips == "24510", c(4, 6)]                       # Gets Baltimore data.

totalEmissions <- (tapply(NEIBaltimore$Emissions,
                          NEIBaltimore$year, sum)) / 1e+3               # Calculates the total
                                                                        # emission per year
                                                                        # in Baltimore.

png("plot2.png", width = 480, height = 480)                             # Open PNG device.

par(cex.lab = 1.0, cex.main = 1.3, cex.sub = 0.8, pch = 19)             # Sets plot parameters.

plot(levels(NEI$year), totalEmissions, type = "l", cex = 0.5,
     xlab = "year", ylab = "Emission (thousand tons)",
     main = "Total Emission of PM 2.5\nBaltimore (MA), 1999-2008.",
     sub = "Source: EPA NAtional Emissions Inventory")                  # Plots the line graphic.
                                                                        # I kept the NEI$year as
                                                                        # the source of the
                                                                        # levels.

points(levels(NEI$year), totalEmissions, pch = 19, cex = 1.5)           # Plots bigger dots.

grid(NULL, NULL)                                                        # Plots the grid lines.
dev.off()                                                               # Close PNG device.
