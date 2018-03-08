#' @importFrom magrittr "%>%"


magick_webshot <- function(...){
  path <- paste0(tempfile(), ".png")
  webshot::webshot(..., file = path)
  webshot <- magick::image_read(path)
  file.remove(path)
  webshot
}
