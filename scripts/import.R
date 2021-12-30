#
# Project Name : STRAP Stata to R , adaptation of common tasks
# Script Name  : import.R
# Summary      : 
# Date created : 
# Author       : 
# Date reviewed:
# Reviewed by  :

# -----------------------------------------------------------------------
# Description : 
# 
# 
# 
# 


# -----------------------------------------------------------------------
# Log version : 


# -----------------------------------------------------------------------

cat("Sources importation\n")

# the file to be imported from sources directory

filename <- file.path(PATH_SOURCES,"imove_hosp_scotland_2021-10-12.csv") 
df <- read.csv(filename)
               

# END script


