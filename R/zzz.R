#' @importFrom magrittr "%>%"


magick_webshot <- function(...){
  path <- paste0(tempfile(), ".png")
  safe_webshot(..., file = path)
  webshot <- magick::image_read(path)
  file.remove(path)
  webshot
}
