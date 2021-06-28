


# Pacakge_Function --------------------------------------------------------
create_temp_dir_pdf <- function(pdf_name){

  search_pdf_dir <- paste0(tempdir(),'/searchPDF')
  search_pdf_subdir <- paste0(tempdir(),'/searchPDF/',pdf_name)
  #search_pdf_subdir_in <- paste0(search_pdf_subdir,'/input')
  search_pdf_subdir_out <- paste0(search_pdf_subdir,'/output')

  if(!'searchPDF' %in% list.dirs(tempdir())){
    dir.create(search_pdf_dir)

  }
  if(!pdf_name %in% list.dirs(search_pdf_dir )){
    dir.create(search_pdf_subdir)
    #dir.create(search_pdf_subdir_in)
    dir.create(search_pdf_subdir_out)
  }

  return(list(search_pdf_dir = search_pdf_dir
              ,search_pdf_subdir = search_pdf_dir
              #,search_pdf_subdir_in = search_pdf_subdir_in
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
    #print(pdf)
    pdf_dir = list(create_temp_dir_pdf(pdf))
    pdf_dir = setNames(pdf_dir,pdf)
    pdf_dir_list <- append(pdf_dir_list,pdf_dir)
    #print(pdf_dir_list)
  }
  return(pdf_dir_list)

}


convert_jpeg_json_per_pdf <- function(python_loc,auth_file_loc,pdf_path,pdf_name,pdf_dir_list){


  pdf_dir = pdf_dir_list[[pdf_name]]
  page_size <- length(pdf_pagesize(pdf_path)$top)



  file_paths <- paste0(pdf_dir$search_pdf_subdir_out,'/',seq(1,page_size,1),'.jpg')

  invisible(pdf_convert(pdf_path , format = "jpg",dpi = 300,pages =NULL,filenames =file_paths))


  #jpg_list <- paste0(output_directory, "/",folder_name,'/',list.files(paste0(output_directory, "/",folder_name), pattern = "*.jpg"), sep = "")
  jpg_list <-list.files(pdf_dir$search_pdf_subdir_out, pattern = "*.jpg")
  jpg_fullpath <- paste0(pdf_dir$search_pdf_subdir_out,'/',jpg_list)



  for(jpg in jpg_fullpath){
    #print(jpg)

    call_python_convert_jpg_gcv (python_loc,auth_file_loc,jpg)

  }


  return(json_path = paste0(str_remove_all(jpg_fullpath,'.jpg'),'.json'))
}


call_python_convert_jpg_gcv <- function(python_loc,auth_file_loc,jpg){

  json_dir = paste0(str_remove_all(jpg,'.jpg'),'.json')
  #print(json_dir)
  # cmd = paste0('"/Users/qianqu/Code/env/ds_py_3.8.10/venv/bin/python" "/Users/qianqu/Code/data_science/project/pythonSearchPDF/get_google_vision.py"  "/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/OCR_example_1.jpg" --json_dir "/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/PID_jenny.json"')
  # cmd = paste0('"',python_loc,'" "','/Users/qianqu/Code/data_science/project/pythonSearchPDF/get_google_vision.py',
  #              '"  "',jpg,'" --json_dir "',json_dir,'"')

  cmd = paste0('',python_loc,' "',system.file("python/get_google_vision.py",package ='searchablePDF'),
               '"  "',jpg,'" --json_dir "',json_dir,'" --auth_file_loc "',auth_file_loc,'"')



  system(cmd)
}



call_python_convert_gcv_hocr <- function(python_loc, json_path){
  # cmd = paste0('"/Users/qianqu/Code/env/ds_py_3.8.10/venv/bin/python"','/Users/qianqu/Code/data_science/project/searchablePDF/OCR/gcv2hocr_new.py',
  # '"/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/PID_1/PID_1_1.json" --savefile "PID_1_2.hocr"')

  # cmd = paste0('"/Users/qianqu/Code/env/ds_py_3.8.10/venv/bin/python"',' /Users/qianqu/Code/data_science/project/searchablePDF/OCR/gcv2hocr_new.py',
  # ' "/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/PID_jenny.json" --savefile "/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/PID_jenny.hocr"')
  #

  for (j in json_path){

    hocr_path <-paste0(str_remove_all(j,'.json'),'.hocr')
    #print(hocr_path)
    #python_loc <- '/Users/qianqu/Code/env/ds_py_3.8.10/venv/bin/python'
    # cmd = paste0('"',python_loc,'" "','/Users/qianqu/Code/data_science/project/searchablePDF/OCR/gcv2hocr_new_v3.py',
    #              '"  "',j,'" --savefile "',hocr_path,'"')

    cmd = paste0('',python_loc,' "',system.file("python/gcv2hocr.py",package ='searchablePDF'),
                 '"  "',j,'" --savefile "',hocr_path,'"')


    system(cmd)
  }
}



call_python_export_pdf <- function(python_loc,pdf_filename,pdf_export_loc,pdf_dir){
  #python_loc <- '/Users/qianqu/Code/env/ds_py_3.8.10/venv/bin/python'
  # cmd = paste0('"', python_loc,'" "','/Users/qianqu/Code/data_science/project/searchablePDF/OCR/convert_pdf_new.py"',
  # ' "/private/var/folders/pv/hs0jp97n3cbfc665v2zd9cnr0000gn/T/RtmpGU6Nt7/searchPDF/PID_1.pdf/output"',
  # ' --pdf_filename "','PID_1.pdf','" --pdf_export_loc "','/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/package_output','"'
  # )
  #
  # cmd = paste0('"', python_loc,'" "','/Users/qianqu/Code/data_science/project/searchablePDF/OCR/convert_pdf_new.py','" "',
  #              pdf_dir,'"',
  #              ' --pdf_filename "',pdf_filename,'" --pdf_export_loc "',pdf_export_loc,'"'
  # )

  cmd = paste0('', python_loc,' "',system.file("python/convert_pdf.py",package ='searchablePDF'),'" "',
               pdf_dir,'"',
               ' --pdf_filename "',pdf_filename,'" --pdf_export_loc "',pdf_export_loc,'"'
  )

  system(cmd)


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
#' @param python_interpreter This is the python interpreter location to be used to create the virtual environment.
#'   By default this is set to NULL. If NULL is set, Python 3.8.7 will be downloaded to your machine in order to create the virtual environment.
#'
#' @import pdftools
#' @import stringr
#' @import reticulate
#' @import googleAuthR
#' @import pbapply
#' @return
#' @export
#'
#' @examples
#' \donttest{
#'
#' google_auth_loc <- 'your google api service authentication.json'
#'
#' pdf_export_loc = '/Users/jenny/pdf_output'
#'
#' input_directory <- 'your input directory'
#'
#' # example if you dont have python installed and want to use the automated downloaded one (3.8.7)
#' convert_pdf_searchable(google_auth_loc,python_interpreter,input_directory,pdf_export_loc)
#'
#' # example if you already have python and you want to use that instead
#' convert_pdf_searchable(google_auth_loc,python_interpreter = 'usr/bin/python',input_directory,pdf_export_loc)
#'
#' }

#
# convert_pdf_searchable <- function(google_auth_file_loc,python_interpreter = NULL,input_directory, pdf_export_loc){
#
#   validate_google_auth(google_auth_file_loc)
#
#   python_info <- setup_python_virtual_env(python_interpreter=python_interpreter)
#
#   python_loc <- python_info$python_loc
#
#   pdf_list <- get_pdf_list(input_directory)
#
#   pdf_dir_list<- generate_dir_pdf_list(pdf_list)
#
#
#   for(i in seq(1,length(pdf_list))){
#
#     #i = 1
#     print(i)
#     pdf_path = pdf_list$pdf_paths[i]
#     pdf_name = pdf_list$pdf_files[i]
#     pdf_dir = pdf_dir_list[i]
#     json_path <- convert_jpeg_json_per_pdf(python_loc = python_loc,
#                                            auth_file_loc = google_auth_file_loc,
#                                            pdf_path=pdf_path,
#                                            pdf_name= pdf_name,
#                                            pdf_dir_list = pdf_dir_list)
#
#
#
#     call_python_convert_gcv_hocr(python_loc ,json_path)
#
#
#     call_python_export_pdf(python_loc,pdf_filename = pdf_name,pdf_export_loc = '/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/package_output'
#                            #,pdf_dir = str_replace_all(pdf_dir[[1]]$search_pdf_subdir_out,'//','/')
#                            ,pdf_dir = pdf_dir[[1]]$search_pdf_subdir_out
#                            #,pdf_dir = '/var/folders/pv/'
#
#     )
#
#
#
#
#
#   }
#
#
#
#
# }






convert_pdf_searchable <- function(google_auth_file_loc,input_directory, pdf_export_loc,python_interpreter = NULL){

  validate_google_auth(google_auth_file_loc)

  python_info <- setup_python_virtual_env(python_interpreter=python_interpreter)

  python_loc <- python_info$python_loc

  pdf_list <- get_pdf_list(input_directory)

  pdf_dir_list<- generate_dir_pdf_list(pdf_list)

  #print(pdf_dir_list)


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

