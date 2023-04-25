# --------------------------------------------------------------------------- #
# tidy_project
# --------------------------------------------------------------------------- #
#' Author: Logan Stundal
#' Date  : 2023-04-24
#'
#' Create a new project directory structure complete with draft template.
#' 
#' \code{tidy_project} creates a new project directory..
#'
#' @param project_name   character to...
#' @param project_home   character to...
#' @param project_author character to...
#' @param create_draft_template boolean to pull quarto draft template from github.com/loganstundal/working-paper (NOTE: requires quarto on system path or returns a warning)
#'
#'@return No return, creates project directory.
# --------------------------------------------------------------------------- #

# rm(list=ls())


tidy_project <- function(project_name,
                         project_home,
                         project_author,
                         create_draft_template = FALSE){
  
  require(readr)
  
  old_dir <- getwd()
  
  project_dir <- paste(project_home, project_name, sep = "/")
  
  if(!dir.exists(project_dir)){dir.create(path = project_dir)}
  

  # --------------
  # Templates - qmd
  q_funs     <- sprintf(read_file("templates/template-function.txt"), project_author, lubridate::today())
  q_tidy     <- sprintf(read_file("templates/template-qmd.txt"), "tidy",     project_author, lubridate::today())
  q_analysis <- sprintf(read_file("templates/template-qmd.txt"), "analysis", project_author, lubridate::today())
  # --------------
    
  # Move into new project directory
  setwd(project_dir)
  
  # Create project-level readme
  cat(paste(
    sprintf("# %s", project_name),
    sprintf("%s is a project to SHORT DESCRIPTION HERE.", project_name),
    "\n## Purpose\n\n## To do list\n- [] get started", sep = "\n"),
    file = "README.md")
  
  # create ABOUT project folder
  dir.create("00-about")
  
  # create DOCUMENTS folder - for miscellaneous pdfs or other research
  dir.create("05-documents")
  
  # create DATA structure folders
  dir.create("10-data")
  cat(paste("This directory contains all data used in the project.",
            "* 01-source ~ contains untouched source data",
            "* 02-tidy ~ containes tidied source data used in analysis",
            "* 03-analysis ~ contains summary statistics and model analysis data",
            sep = "\n"),
      file = "10-data/README.md")
  dir.create("10-data/01-source")
  dir.create("10-data/02-tidy")
  dir.create("10-data/03-analysis")
  
  # Create SCRIPTS directories
  dir.create("20-scripts")
  cat(template-readme_data.txt,
      file = "20-scripts/README.md")
  dir.create("20-scripts/00-functions")
  cat(q_funs, file = "20-scripts/00-functions/00-function_template.qmd")
  dir.create("20-scripts/01-tidy")
  cat(q_tidy, file = "20-scripts/01-tidy/00-tidy_template.qmd")
  dir.create("20-scripts/02-analysis")
  cat(q_analysis, file = "20-scripts/02-analysis/00-analysis_template.qmd")
  
  # create RESULTS directories
  dir.create("30-results")
  cat(paste("This directory contains all results generated with using scripts in `20-scripts/02-analysis/`",
            "* 01-tables  ~ contains table objects",
            "* 02-figures ~ containes figure objects",
            sep = "\n"),
      file = "30-results/README.md")
  dir.create("30-results/01-tables")
  dir.create("30-results/02-figures")
  
  # create DRAFT directory
  dir.create("40-draft")
  
  if(create_draft_template){
    os <- Sys.info()["sysname"]
    if(os %in% c("Linux", "Darwin")){
      check <- suppressWarnings({system("which quarto", intern = T)})
    } else if(os == "Windows"){
      check <- system("where quarto")
    }
    
    if(length(check) == 0){
      warning(paste0("quarto not found on system. quarto is required to generate draft working directory. ",
                     "Draft sub-directory not created. See <https://quarto.org/docs/get-started/> to install quarto on your system."))
    } else{
      setwd("40-draft")
      
      if(os == "Windows"){
        system("quarto.cmd use template --no-prompt --quiet loganstundal/working-paper")
      } else{
        system("quarto use template --no-prompt --quiet loganstundal/working-paper")
      }
    }
  }
  
  setwd(old_dir)
}

tidy_project(project_name = "testing",
             project_home = "~/Documents",
             project_author = "Logan",
             create_draft_template = T)




