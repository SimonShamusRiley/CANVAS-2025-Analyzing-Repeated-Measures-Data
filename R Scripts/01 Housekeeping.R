#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 1: Housekeeping (i.e., Preparing the R Environment)                     #
#==============================================================================#

# Install required packages (this only needs to be done once when you install
# or update R, so you can skip this if these packages are already installed)
install.packages('tidyverse')

# Load required packages
library(readxl)
library(tidyverse)
library(lme4)      
library(lmerTest)
library(nlme)
library(mgcv)
library(emmeans) 
library(multcomp)
library(car)
library(ggResidpanel)
library(writexl)

# Set the working directory as the "R Script" folder within the workshop 
# materials (the actual path to wherever you extracted those files can be
# copied from the file browser)
setwd("path/where/you/saved/workshop/Materials/R Scripts") 

# Set global options (increase default output when printing data frames)
options(dplyr.width = Inf, 
        pillar.print_min = 100, 
        pillar.print_max = 100)

##### Import and Prepare the Data ####
file_in <- 'soiln_long.xlsx'

# Comment/uncomment to select a response variable
#resp_name <- "NH"
#resp_name <- "NO"
resp_name <- "NHNO"

# Read data and create system specific blocks and subjectID for depth, then
# filter data frame to retain a single response variable
soilN <- read_excel(path = file_in, sheet = "soiln_long") %>%
    mutate(block = paste0(substr(system, 1, 1), block),
           subject_depth = paste0(block, trt, year, DAP), 
           system = factor(system),
           trt = factor(trt),
           DAP = factor(DAP), 
           D_class = factor(D_class), 
           year = factor(year)) %>%
  filter(resp_name == !!resp_name)

# Check data
head(soilN)
str(soilN)





