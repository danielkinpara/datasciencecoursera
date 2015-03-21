########################################################################
#
# This code reads the PM 2.5 data from the file "summaryscc_PM35.rds",
# plots the emission from motor vehicles for Baltimore and Los Angeles,
# from 1999 to 2008, and outputs a file named "plot6.png" with two
# graphs showing the total emission per year from vehicles for each
# city. It uses the data in the file "Source_Classification_Code.rds"
# in order to find out which emission comes from vehicles.
#
# The code file must be placed in the same folder of the data files.
# The PNG file is saved in the same folder.
#
# (c) Daniel Kinpara, 2015.
#
########################################################################
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")                                   # Reads the data file.
SCC <- readRDS("Source_Classification_Code.rds")                        # Reads the SCC file.

NEI <- transform(NEI, year = factor(year))                              # Transforms year into
# a factor.

SCCcodes <- NEI$SCC %in%
        SCC[grep("[Hh]ighway.*[Vv]ehicle", SCC$Short.Name), "SCC"]      # Creates a logical
# vector where the
# vehicle source is set
# to TRUE.

NEIBaltimore <- NEI[SCCcodes & NEI$fips == "24510", c(4,6)]             # Gets data for Baltimore.
NEIBaltimore[,"city"] <- "1"                                            # Adds a column city.

NEILosAngeles <- NEI[SCCcodes & NEI$fips == "06037", c(4,6)]            # Gets data for LA.
NEILosAngeles[,"city"] <- "2"                                           # Adds a column city.

NEIcities <- rbind(NEIBaltimore, NEILosAngeles)                         # Binds both data sets.
NEIcities <- transform(NEIcities,
                       city = factor(city, levels = c(1, 2), labels = c("Baltimore", "Los Angeles")))

png("plot6.png", width = 480, height = 480)                             # Opens PNG device.

q <- ggplot(NEIcities, aes(x = year, y = Emissions))                    # Builds the basic layer.

q + geom_point(size = 4, alpha = 1/3) +                                 # Adds points.
        ylim(0, 25) +                                                   # Sets Y limits.
        geom_smooth(method = "lm", aes(group = city), se = FALSE) +     # Adds trend lines.
        facet_wrap(~city) +                                             # Adds panels.
        labs(x = "year", y = "Emission (tons)") +                       # Adds labels.
        labs(title = "Emission of PM 2.5 from Motor Vehicles
             Baltimore and Los Angeles, 1999-2008.")

dev.off()                                                               # Close PNG device.
