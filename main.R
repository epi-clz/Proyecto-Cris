#
# Project Name : STRAP Stata to R , adaptation of common tasks
# Script Name  : main.R
# Summary      : main script to call all other specific scripts 
# Date created : 2021-12-23
# Author       : G.DESVE
# Date reviewed:
# Reviewed by  :

# -----------------------------------------------------------------------
# Description : 
# main call all other scripts specifics to each common task
# 
# 
# 


# -----------------------------------------------------------------------
# Change Log : 


# -----------------------------------------------------------------------

if (! file.exists("config.R")) {
  stop("main.R script should be run from root directory")
}

source("config.R")


SourceFile(PATH_SCRIPTS,"import.R")


# END script
