########################################################################
#
# This code reads the PM 2.5 data from the file "summaryscc_PM35.rds",
# plots the emission in Baltimore (MA) by source, from 1999 to 2008,
# and outputs a file named "plot3.png" containing four graphics, one for
# each emission source ("type").
#
# The code file must be placed in the same folder of the data file.
# The PNG file is saved in the same folder.
#
# (c) Daniel Kinpara, 2015.
#
########################################################################

library(ggplot2)                                                        # Loads ggplot2 package.

NEI <- readRDS("summarySCC_PM25.rds")                                   # Reads the data file.

NEI <- transform(NEI, year = factor(year), type = factor(type))         # Transforms variables
                                                                        # "year" and "type" into
                                                                        # factors.

NEIBaltimore <- NEI[NEI$fips == "24510", 4:6]                           # Gets Baltimore data.

png("plot3.png", width = 480, height = 480)                             # Opens PNG device.

q <- ggplot(NEIBaltimore, aes(x = year, y = Emissions))                 # Builds the basic layer.

q + geom_point(size = 4, alpha = 1/3) +                                 # Adds points.
        ylim(0, 50) +                                                   # Sets Y limits.
        facet_wrap(~type) +                                             # Adds panels.
        geom_smooth(method = "lm", aes(group = type)) +                 # Adds trend lines.
        labs(x = "year", y = "Emissions (tons)") +                      # Adds labels.
        labs(title = "Emission of PM 2.5 by source
             Baltimore (MA), 1999-2008.")

dev.off()                                                               # Closes PNG device.
