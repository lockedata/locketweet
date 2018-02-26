#' Title
#'
#' @param url url to post
#' @oaram path where to save the image?
#'
#' @return
#' @export
#'
#' @examples webshot_prettyplease("https://itsalocke.com/blog/how-to-maraaverickfy-a-blog-post-without-even-reading-it/",
#'                                path = "here.png")
webshot_prettyplease <- function(url, path){

  df <- lockedata_blog[lockedata_blog$url == url,]

  tempdir_path <- paste0(tempdir(), "\\screenshots")

  # webshot itself
  message("now webshoting!")
  fs::dir_create(tempdir_path)
  get_post_info(df) %>%
    dplyr::filter(number > 1) %>%
    split(.$header) %>%
    purrr::walk(shot_region, path = tempdir_path)



  message("now prettifying!")
  # paths to webshots
  imgs_paths <- fs::dir_ls(tempdir_path)

  # params that we'll need
  width <- 998
  height <- 300

  # empty rectangle needed once or twice
  empty_rect <- magick::image_blank(width, height, color = "#2165B6")


  imgs <- magick::image_read(imgs_paths) %>%
    magick::image_resize(geometry = paste0(width, "x", height))

  # empty rectangle if we have an o
  row_no <- floor(length(imgs)/2)


  col1 <- magick::image_append(c(empty_rect, imgs[1:row_no]),
                               stack = TRUE)
  col2 <- magick::image_append(imgs[(row_no + 1): length(imgs)],
                               stack = TRUE)
  if(length(imgs_paths) == length(imgs)*2){
    col2 <- magick::image_append(c(col2, empty_rect), stack = TRUE)
  }

  # bind regions
  all <- magick::image_append(c(col1, col2))

  # prepare title
  logo <- magick::image_read(system.file("extdata/assets", "logo.png", package = "locketweet")) %>%
    magick::image_resize("200x50")

  title <- magick::image_blank((width * 2 - 20), 50, color = "white") %>%
    magick::image_composite(logo, offset = paste("+", width * 2 - 220, "+0")) %>%
    magick::image_annotate(paste0(" ", toupper(df$title), " "),
                                  size = 40,
                                  font = "roboto",
                           boxcolor = "white",
                           color = "#E8830C") %>%
    magick::image_border("#2165B6", "10x10")

  all <- magick::image_append(c(title, all), stack = TRUE)

  author <- tolower(df$author)
  chibi_filename <- sample(chibis$chibi[chibis$person == author])
  chibi_path <- system.file("extdata/assets", chibi_filename, package = "locketweet")
  chibi <- magick::image_read(chibi_path) %>%
    magick::image_resize(paste0("300x", height - 20))

  pretty <- magick::image_composite(all, chibi,
                                    offset = paste0("+", width/2, "+", height*0.4))

  magick::image_write(pretty, path = path)
  # clean!
  fs::dir_delete(tempdir_path)
}
