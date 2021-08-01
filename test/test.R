# # #library(testthat)
# # #test_that('convert')
# library(searchablePDF)
#
# google_auth_file <- 'C:/Users/pcwng/Documents/auth/google_auth.json'
# input_directory <- paste0(getwd(),'/test/input_dir')
# pdf_export_loc <- paste0(getwd(),'/test/output_dir')
#
# convert_pdf_searchable(google_auth_file,input_directory,pdf_export_loc)


#
#
# google_auth_file_loc <- '/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/auth/auth.json'
#
#
# pdf_export_loc = '/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/package_output'
# # #2. specify pdf input directory
#
# input_directory <- '/Users/qianqu/Code/data_science/project/searchablePDF/OCR/R/'
#
#
# call_python_convert_jpg_gcv <- function(python_loc,auth_file_loc,jpg){
#
#   json_dir = paste0(str_remove_all(jpg,'.jpg'),'.json')
#
#
#   cmd = paste0('',python_loc,' "',system.file("python/get_google_vision.py",package ='searchablePDF'),
#                '"  "',jpg,'" --json_dir "',json_dir,'" --auth_file_loc "',auth_file_loc,'"')
#
#
#
#   system(cmd, intern = T)
# }
# library(magick)
#
# python_loc <- '/Users/qianqu/.virtualenvs/searchablePDF/bin/python'
# jpg <- '/Users/qianqu/Code/data_science/project/searchablePDF/OCR/share/16.jpg'
# img = image_read(jpg) %>% image_resize('600X600')
#
# image_write(img,'/Users/qianqu/Code/data_science/project/searchablePDF/OCR/share/16_2.jpg')
# call_python_convert_jpg_gcv(python_loc,google_auth_file_loc,jpg)
#
#
#
#
# convert_pdf_searchable(google_auth_file_loc = google_auth_file_loc,input_directory= input_directory,pdf_export_loc = pdf_export_loc)
#
