## How to setup GitHub in RStudio
## (You must have a github account)

library(devtools)

## set your user name and email:
usethis::use_git_config(user.name = "epi-gde", user.email = "gilles@desve.fr")

## create a personal access token for authentication:
#usethis::create_github_token() 
## in case usethis version < 2.0.0: usethis::browse_github_token() (or even better: update usethis!)

## set personal access token:
## here insert your own personal access token
credentials::set_github_pat("xxxXXXxxx")

#### Restart R! ###########################################################

# ----------------------------------------------------------------------------
# Not recommended but it's also possible to put PAT into R environment
# by adding GITHUB_PAT=xxxyyyzzz
# usethis::edit_r_environ()


#### Verify settings ######################################################
usethis::gh_token_help() 

usethis::git_sitrep()

# if something wrong gitcreds better  manage PAT conflicts
library(gitcreds)
gitcreds_get()
gitcreds_set()

