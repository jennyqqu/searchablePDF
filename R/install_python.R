#setup python env


#' Setup python virtual environment for SearchablePDF
#'
#' @description
#' This function creates a virtual environment that SearchablePDF will run on. You can provide the your existing Python interpreter location if you want to use that.
#'
#' @details
#' The main function convert_pdf_searchable will automatically run a validation to check if you have the correct virtual env setup and install it by running this function.
#'
#' @param python_interpreter This is the python interpreter location to be used to create the virtual environment.
#'   By default this is set to NULL. If NULL is set, Python 3.8.7 will be downloaded to your machine in order to create the virtual enviornment.
#' @param force_installation This will force to recreate the virtual environment
#'
#' @return virtual environment path information
#' @export
#'
#' @examples
#' \dontrun{
#' # example to download a new Python if you dont already have one.
#' setup_python_virtual_env()
#'
#' # example to use the existing Python version
#' setup_python_virtual_env(python_interpreter = 'usr/bin/python')
#'
#'
#'
#' }
#'
#'
#'
#'
#'
setup_python_virtual_env<- function(python_interpreter=NULL,force_installation = FALSE){


  if (force_installation || !virtualenv_exists('searchablePDF')){
    #create virutalenvs

    if(force_installation){
      cat("\n You chose force_installation option for python virtual environment.\n\n")
      user_answer <- askYesNo(msg = 'Do you want to continue reinstall Python and setup virtual env? ', default = TRUE,
                              prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
      )


    }
    else if(!virtualenv_exists('searchablePDF')){
      cat("\n There is no python virtual environment detected for SeachablePDF.\n\n")


      user_answer <- askYesNo(msg = 'Do you want to continue install Python and setup virtual env? ', default = TRUE,
                              prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
      )


    }

    #If no user permission obtained, stop the program, else continue
    if(!user_answer){
      cat("\n Installation virtual environment is cancelled.\n\n")
      stop('User cancelled Python installation/Permission Denied')
    }

    if(is.null(python_interpreter)){

        version <- "3.8.7"
        install_python(version = version)


        virtualenv_create("searchablePDF", python_version = version)
      }

      else{

        virtualenv_create("searchablePDF", python = python_interpreter,python_version = version)


      }




    #run a command to upgrade pip

    cmd = paste0(virtualenv_root(),'/searchablePDF/bin/python3',' ','-m pip install --upgrade pip')

    system(cmd)

    cat("\nVirtual Environment Created\n\n")

    tryCatch(
      {

        cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install google-cloud-vision')
        system(cmd)
        cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install reportlab')
        system(cmd)
        cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install lxml')
        system(cmd)
        #py_install('google-cloud-vision',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
        #py_install('reportlab',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
        #py_install('lxml',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
      },error = function(e){
        cat("\nHvaing issues with installing one of the python packages into virtual enviornemnt. Check error message for details.\n\n")
        stop(e)

      })
    cat("\nInstallation Completed.\n\n")

    return(list(python_loc =paste0(virtualenv_root(),'/searchablePDF/bin/python3') ))
  }else{

    return(list(python_loc =paste0(virtualenv_root(),'/searchablePDF/bin/python3') ))
  }





}

validate_python_virtual_env <- function(){

  if (!virtualenv_exists('searchablePDF')){
    return(setup_python_virtual_env())


  }
  return(setup_python_virtual_env())

}


validate_google_auth <- function(google_auth_file_loc){

  gar_auth_service(google_auth_file_loc)
  return(TRUE)

}





