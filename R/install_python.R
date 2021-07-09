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
#' @param virtual_path virutal env path
#'
#' @return virtual environment path information
#' @import reader
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
#' # example to change the virtual environment working directory (Default: ~/.virtualenv)
#' setup_python_virtual_env(python_interpreter = 'usr/bin/python', virtual_path = 'my/path/to/.virtualenv')
#'
#'
#'
#' }
#'
#'
#'
#'
#'
# setup_python_virtual_env<- function(python_interpreter=NULL,force_installation = FALSE){
#
#
#   if (force_installation || !virtualenv_exists('searchablePDF')){
#     #create virutalenvs
#
#     if(force_installation){
#       cat("\n You chose force_installation option for python virtual environment.\n\n")
#       user_answer <- askYesNo(msg = 'Do you want to continue reinstall Python and setup virtual env? ', default = TRUE,
#                               prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
#       )
#
#
#     }
#     else if(!virtualenv_exists('searchablePDF')){
#       cat("\n There is no python virtual environment detected for SeachablePDF.\n\n")
#
#
#       user_answer <- askYesNo(msg = 'Do you want to continue install Python and setup virtual env? ', default = TRUE,
#                               prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
#       )
#
#
#     }
#
#     #If no user permission obtained, stop the program, else continue
#     if(!user_answer){
#       cat("\n Installation virtual environment is cancelled.\n\n")
#       stop('User cancelled Python installation/Permission Denied')
#     }
#
#     if(is.null(python_interpreter)){
#
#         version <- "3.8.7"
#         #install_python(version = version)
#         #virtualenv_create("searchablePDF", python_version = version)
#
#         py_install(packages = c('google-cloud-vision','lxml','reportlab'),env = 'searchPDF', method = 'virtualenv',version = version)
#
#       }
#
#       else{
#
#
#         virtualenv_create("searchablePDF", python = python_interpreter)
#
#
#       }
#
#
#
#
#     #run a command to upgrade pip
#
#     #cmd = paste0(virtualenv_root(),'/searchablePDF/bin/python3',' ','-m pip install --upgrade pip')
#
#     #system(cmd)
#
#     cat("\nVirtual Environment Created\n\n")
#
#     tryCatch(
#       {
#
#         py_install(c('google-cloud-vision','lxml','reportlab'))
#
#
#        pip_exc <- get_exc_by_os(is_windows(), file = 'pip')
#         #cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install google-cloud-vision')
#
#         cmd = paste0(pip_exc,' ','install google-cloud-vision')
#         system(cmd,intern = T)
#
#         #cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install reportlab')
#         cmd = paste0(pip_exc,' ','install reportlab')
#         system(cmd)
#
#         #cmd = paste0(virtualenv_root(),'/searchablePDF/bin/pip',' ','install lxml')
#
#         cmd = paste0(pip_exc,' ','install lxml')
#         system(cmd)
#         #py_install('google-cloud-vision',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
#         #py_install('reportlab',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
#         #py_install('lxml',envname = 'searchablePDF',method = c('virtualenv'),pip = TRUE)
#       },error = function(e){
#         cat("\nHvaing issues with installing one of the python packages into virtual enviornemnt. Check error message for details.\n\n")
#         stop(e)
#
#       })
#     cat("\nInstallation Completed.\n\n")
#
#     return(list(python_loc =  get_exc_by_os(is_windows(), file = 'python')))
#   }else{
#
#     return(list(python_loc =  get_exc_by_os(is_windows(), file = 'python')))
#   }
#
#
#
#
#
# }
#




setup_python_virtual_env<- function(python_interpreter=NULL,force_installation = FALSE,virtual_path = NULL){
  if(!is.null(virtual_path)){
    Sys.setenv('WORKON_HOME' = virtual_path)

  }


    #create virutalenvs
  tryCatch({
    if (force_installation || !virtualenv_exists('searchablePDF')){
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
        version = '3.8.4'
        if(is_windows()){
        #miniconda
        py_install(packages = c('google-cloud-vision','lxml','reportlab','openssl'),env = 'searchablePDF', method = 'virtualenv',version = version)
        }else{
        #virtualenv
        install_python(version = version)
        py_install(packages = c('google-cloud-vision','lxml','reportlab','openssl-python'),env = 'searchablePDF', method = 'virtualenv',version = version)
        }
      }else{
        #use the python-non conda version and install package one by one
        virtualenv_create("searchablePDF", python = python_interpreter)
        pip_loc =  get_exc_by_os(is_windows(), file = 'python')

        cmd = paste0(pip_loc,' ','-m pip install --upgrade pip')
        system(cmd , intern = T)
        cmd = paste0(pip_loc,' ','install google-cloud-vision')
        system(cmd , intern = T)
        cmd = paste0(pip_loc,' ','install lxml')
        system(cmd , intern = T)
        cmd = paste0(pip_loc,' ','install reportlab')
        system(cmd , intern = T)
        cmd = paste0(pip_loc,' ','install openssl-python')
        system(cmd , intern = T)
        #py_install(packages = c('google-cloud-vision','lxml','reportlab','openssl-python'),env = 'searchablePDF', method = 'virtualenv',version = version,pip = T)

      }







    #cat("\nVirtual Environment Created\n\n")

    cat("\nInstallation Completed.\n\n")
    print(get_exc_by_os(is_windows(), file = 'python'))

    return(list(python_loc =  get_exc_by_os(is_windows(), file = 'python')))
  }else{
    print(get_exc_by_os(is_windows(), file = 'python'))
    return(list(python_loc =  get_exc_by_os(is_windows(), file = 'python')))
  }



  },error = function(e){
   print(error)
    virtualenv_remove('searchablePDF',confirm = F)

  })





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


is_windows <- function(){
  return( as.character(Sys.info()['sysname']) == 'Windows')


}


#if exc not found in vir_dir, new one will create
search_file_in_vir_dir <- function(file){
  if(Sys.getenv('WORKON_HOME') == ''){
 print('here')
  return(find.file(file, list.dirs(paste0(Sys.getenv('HOME'),'/.virtualenvs/searchablePDF/'))))
  }else{
    return(find.file(file, list.dirs(paste0(Sys.getenv('WORKON_HOME'),'/searchablePDF/'))))

  }


}

get_exc_by_os <- function(is_windows, file){
  if(is_windows){
    print('windows')
    exc <- search_file_in_vir_dir(paste0(file,'.exe'))
    return(exc)
  }


  return( search_file_in_vir_dir(file))

}



