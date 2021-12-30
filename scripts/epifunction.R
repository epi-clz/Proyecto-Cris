
macro <- function(x) {
  R.utils::gstring(x) 
}


catret  <- function(...) {
  cat(...,"\n")
}



file.ext <- function(text) {
  x <- strsplit(text, "\\.")
  i <- length(x[[1]])
  ext <- ""
  if (i > 1) {
    ext <- x[[1]][i]
  }
  ext
}

file.name <- function(text) {
  name <- basename(text)
  x <- strsplit(name, "\\.")
  x[[1]][1]
}

# count number of specific char into a text using reg expr
charcount <- function(pattern, stosearch) {
  lengths(regmatches(stosearch, gregexpr(pattern, stosearch)))
  # length(attr(gregexpr(pattern,stosearch)[[1]],
  #            "match.length")[attr(gregexpr(pattern,stosearch)[[1]], "match.length")>0])
}


read <- function(filename = "", factorise = FALSE, lowercase= FALSE, label = NULL,...) {
  # no file ? choose one
  if (filename == "") {
    catret("retrieving file tree...please wait.")
    r <- try(filename <- file.choose())
    if (inherits(r, "try-error")) {
      # user have cancelled , stop now
      return(r)
    }
  }
  # try to extract name...
  ext <- tolower(file.ext(filename))
  name <- file.name(filename)
  if (file.exists(filename)) {
    # file exists.. let's go
    if (ext == "csv") {
      # look at the content
      # count and identify separator
      test <- readLines(filename , n = 2)
      comma1 <- charcount(",", test[1])
      semicol1 <- charcount(";", test[1])
      if (comma1 > 0) {
        df <- utils::read.csv(filename,as.is = !factorise,...)
      } else if (semicol1  > 0) {
        df <- utils::read.csv2(filename,as.is = !factorise,...)
      } else {
        red("Separator not identified in :")
        normal("\n")
        catret(test[[1]])
        catret(test[[2]])
      }
    } else  if (ext == "dta") {
      # foreign packages is required
      r <- requireNamespace("foreign", quietly = TRUE)
      if (!r) {
        message("Package foreign required")
      }
      df <- foreign::read.dta(filename)
    } else if (ext == "rec") {
      # foreign packages is required
      r <- requireNamespace("foreign", quietly = TRUE)
      if (!r) {
        message("Package foreign required")
      }
      df <- foreign::read.epiinfo(filename)
    } else if (ext == "rda" | ext == "rdata" ) {
      # load return name and load content into selected env
      df <- load(filename)
      df <- get(df)
    } else {
      cat("Extension '", ext, "'not found")
    }
    if (!missing(label)) {
      attr(df, "label") <- label
    }
    if (is.data.frame(df)) {
      fileatt <- dim(df)
      if (lowercase) {
        names(df)<-casefold(names(df))
      }
      cat("File ", filename, " loaded. \n")
      cat(fileatt[1],
          "Observations of ",
          fileatt[2],
          " variables. Use str(name) for details")
      invisible(df)
    }
  } else {
    # file doens't exists ??
    cat("File \"", filename, "\" doesn't exist.\n", sep = "")
    cat("Verify your working directory. Current is", getwd())
    
  }
}



compare <-  function(dfmod, dftest) {
  
  cmod <- ncol(dfmod)
  ctest <- ncol(dftest)
  cat("Number of variables. Modele : ",cmod,"/ Tested :",ctest,"\n")
  
  colmod <-  colnames(dfmod)
  coltest <-  colnames(dftest)
  
  
  difnew <- as.data.frame(setdiff(coltest, colmod))
  cat("New columns in tested :",unlist(difnew),"\n")
 
  difmiss <- as.data.frame(setdiff(colmod,coltest))

  cat("Missing columns in tested :",unlist(difmiss),"\n")
  
  
  
  tmod <- sapply(dfmod, typeof )
  ttest <- sapply(dftest, typeof)
  tmod <- cbind(colmod,tmod)
  ttest <- cbind(coltest,ttest)
  tcomp <- merge(tmod,ttest, by.x="colmod", by.y="coltest",all=TRUE)
  tcomp <- tcomp[is.na(tcomp$tmod)|is.na(tcomp$ttest)|(tcomp$tmod != tcomp$ttest),]
  colnames(tcomp) <- c("Variable","Modele","Tested")
  typedif <- nrow(tcomp)
  cat(typedif , " Variable with different type\n\n")
  tcomp
}
 
# testing the compare function

# we load scotland data
# filename <- file.path(PATH_SOURCES,"imove_hosp_scotland_2021-10-12.csv") 
# df <- read.csv(filename)

# test of read function
df <- read()


# the modele
dfmod <- df
dfmod <- dfmod[1,]

#the dataset to be tested
dftest <- df


compare(dfmod,dftest) 

# we add two errors to dftest
colnames(dftest)[1] <- "Pays"
colnames(dftest)[4] <-  "accord"

compare(dfmod,dftest)

# drop a column of dftest
dftest <- dftest[!colnames(dftest) %in% c("sex")]


#add an empty  row to dftest
dftest[nrow(dftest)+1,] <- NA

# change a type
dftest[1,2] <- as.character(dftest[1,2])

compare(dfmod,dftest)




