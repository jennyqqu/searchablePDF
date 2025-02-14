


# Pacakge_Function --------------------------------------------------------
create_temp_dir_pdf <- function(pdf_name){

  search_pdf_dir <- paste0(tempdir(),'/searchPDF')
  search_pdf_subdir <- paste0(tempdir(),'/searchPDF/',pdf_name)

  search_pdf_subdir_out <- paste0(search_pdf_subdir,'/output')

  if(!'searchPDF' %in% list.files(tempdir())){

    dir.create(search_pdf_dir)

  }
  if(!pdf_name %in% list.files(search_pdf_dir )){
    dir.create(search_pdf_subdir)

    dir.create(search_pdf_subdir_out)
  }

  return(list(search_pdf_dir = search_pdf_dir
              ,search_pdf_subdir = search_pdf_dir

              ,search_pdf_subdir_out = search_pdf_subdir_out

  ))
}




get_pdf_list <- function(input_directory){
  file_list <- list.files(input_directory)
  pdf_files <-  file_list[which(str_detect(file_list ,'\\.pdf'))]

  pdf_paths <- paste0(input_directory,'/',pdf_files)
  return(list(pdf_paths = pdf_paths,
              pdf_files = pdf_files
  ))
}






generate_dir_pdf_list <- function(pdf_list){
  pdf_dir_list <- list()
  for (pdf in pdf_list$pdf_files){

    pdf_dir = list(create_temp_dir_pdf(pdf))
    pdf_dir = setNames(pdf_dir,pdf)
    pdf_dir_list <- append(pdf_dir_list,pdf_dir)

  }
  return(pdf_dir_list)

}





convert_jpeg_json_per_pdf <- function(python_loc,auth_file_loc,pdf_path,pdf_name,pdf_dir_list){


  pdf_dir = pdf_dir_list[[pdf_name]]

  print(pdf_path)
  page_size <- length(pdf_pagesize(pdf_path)$top)



  file_paths <- paste0(pdf_dir$search_pdf_subdir_out,'/',seq(1,page_size,1),'.jpg')

  invisible(pdf_convert(pdf_path , format = "jpg",dpi = 300,pages =NULL,filenames =file_paths,verbose = F))



  jpg_list <-list.files(pdf_dir$search_pdf_subdir_out, pattern = "*.jpg")
  jpg_fullpath <- paste0(pdf_dir$search_pdf_subdir_out,'/',jpg_list)



  for(jpg in jpg_fullpath){


    call_python_convert_jpg_gcv (python_loc,auth_file_loc,jpg)

  }


  return(json_path = paste0(str_remove_all(jpg_fullpath,'.jpg'),'.json'))
}


call_python_convert_jpg_gcv <- function(python_loc,auth_file_loc,jpg){

  json_dir = paste0(str_remove_all(jpg,'.jpg'),'.json')


  cmd = paste0('',python_loc,' "',system.file("python/get_google_vision.py",package ='searchablePDF'),
               '"  "',jpg,'" --json_dir "',json_dir,'" --auth_file_loc "',auth_file_loc,'"')



  system(cmd, intern = T)
}



call_python_convert_gcv_hocr <- function(python_loc, json_path){


  for (j in json_path){

    hocr_path <-paste0(str_remove_all(j,'.json'),'.hocr')

    cmd = paste0('',python_loc,' "',system.file("python/gcv2hocr.py",package ='searchablePDF'),
                 '"  "',j,'" --savefile "',hocr_path,'"')


    system(cmd, intern = T)
  }
}



call_python_export_pdf <- function(python_loc,pdf_filename,pdf_export_loc,pdf_dir){


  cmd = paste0('', python_loc,' "',system.file("python/convert_pdf.py",package ='searchablePDF'),'" "',
               pdf_dir,'"',
               ' --pdf_filename "',pdf_filename,'" --pdf_export_loc "',pdf_export_loc,'"'
  )

  system(cmd , intern = T)


}

verify_virtualenv <- function(){
  if (virtualenv_exists('searchablePDF')){
    return(TRUE)
  }else{
    stop("\n Please run setup_python_virtual_env() to create the virtual env.
        \n\n")
    return(FALSE)

  }

}



#' Batch Convert PDFs into searchable PDF
#'
#' @description
#' This function converts a list of PDFs into searchable PDF using GoogleVisionAPI
#'
#' @details
#' To obtain the authentication json file.
#' Navigate to it via: Google Dev Console > Credentials > New credentials > Service account Key > Select service account > Key type = JSON
#'
#' Download the JSON file.
#'
#' @param google_auth_file_loc This is the file path of your Google Cloud API service account json file
#' @param input_directory Folder location that contains the list of PDFs you want to convert
#' @param pdf_export_loc  Folder location for converted PDF
#' @import pdftools
#' @import stringr
#' @import reticulate
#' @import googleAuthR
#' @import pbapply
#' @import stats

#' @export
#'
#' @examples
#' \dontrun{
#'
#' google_auth_loc <- 'your google api service authentication.json'
#'
#' pdf_export_loc = '/Users/jenny/pdf_output'
#'
#' input_directory <- 'your input directory'
#'
#' # example if you dont have python installed and want to use the automated
#' downloaded one (3.8.7)
#' setup_python_virtual_env()
#' convert_pdf_searchable(google_auth_loc,input_directory,pdf_export_loc)
#'
#'
#' # example if you already have python and you want to use that instead
#' setup_python_virtual_env(python_interpreter = 'usr/bin/python')
#' convert_pdf_searchable(google_auth_loc,input_directory,pdf_export_loc)
#'
#'
#' # example if you want to change the default virutalenv path into something
#' else
#' setup_python_virtual_env(python_interpreter = 'usr/bin/python',
#'  virtual_path = 'my/path/to/.virtualenv')
#' convert_pdf_searchable(google_auth_loc,input_directory,pdf_export_loc)
#'
#' }








convert_pdf_searchable <- function(google_auth_file_loc,input_directory, pdf_export_loc){

  validate_google_auth(google_auth_file_loc)

  verify_virtualenv()


  python_info <- setup_python_virtual_env(python_interpreter=NULL,virtual_path=NULL)

  python_loc <- python_info$python_loc

  pdf_list <- get_pdf_list(input_directory)

  pdf_dir_list<- generate_dir_pdf_list(pdf_list)

  print('here')
  print(pdf_list)
  print(length(pdf_list))

  invisible(pbmapply(function(pdf_path = pdf_list$pdf_paths,
                  pdf_name = pdf_list$pdf_files

                  ,pdf_dir =pdf_dir_list ){


    json_path <- convert_jpeg_json_per_pdf(python_loc = python_loc,
                                           auth_file_loc = google_auth_file_loc,
                                           pdf_path=pdf_path,
                                           pdf_name= pdf_name,
                                           pdf_dir_list = pdf_dir_list)



    call_python_convert_gcv_hocr(python_loc ,json_path)


    call_python_export_pdf(python_loc,pdf_filename = pdf_name,pdf_export_loc = pdf_export_loc

                           ,pdf_dir = pdf_dir$search_pdf_subdir_out


    )

    cat(paste0('Completed processing ', pdf_name, '\n'))
  },pdf_list$pdf_paths,pdf_list$pdf_files,pdf_dir_list))













}

