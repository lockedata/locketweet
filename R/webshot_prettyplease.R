#' Title
#'
#' @importFrom magrittr "%>%"
#'
#' @param url url to post
#'
#' @return
#' @export
#'
#' @examples webshot_prettyplease("https://itsalocke.com/blog/center-across-selection/")
webshot_prettyplease <- function(url){

  width <- 1200
  height <- 600

  df <- lockedata_blog[lockedata_blog$url == url,]

  # head
  head <-  magick_webshot(url = url,
                          vwidth = 550,
                          cliprect = c(180, 0, 550, 550))
  head <-  magick::image_crop(head, "550x500+0+50")

  # background
  empty_rect <- magick::image_blank(width, height, color = "#2165B6")

  # logo
  logo <- magick::image_read(system.file("extdata/assets",
                                         "Locke Data Logo White.png",
                                         package = "locketweet")) %>%
    magick::image_resize("200x50") %>%
    magick::image_rotate(degrees = 270)



  # chibi
  author <- tolower(df$author)
  chibi_filename <- sample(chibis$chibi[chibis$person == author], size = 1)
  chibi_path <- system.file("extdata/assets", chibi_filename, package = "locketweet")
  chibi <- magick::image_read(chibi_path) %>%
    magick::image_resize(paste0("250x", height - 20))

  # bubble

  bubble <- magick::image_read(system.file("extdata/assets", "rect933.png", package = "locketweet")) %>%
    magick::image_resize("250x250")
  compliment <- praise::praise(template = " Read my ${adjective} post! ")

  # all
  pretty <- empty_rect %>%
    magick::image_composite(bubble, offset = "+215+20")%>%
    magick::image_annotate(paste0(" ", toupper(df$title), " "),
                           size = 40,
                           font = "Contrail One",
                           color = "white") %>%
    magick::image_composite(logo, offset = "+1150+50") %>%
    magick::image_composite(head, offset = "+500+75") %>%
    magick::image_composite(chibi, offset = "+10+210") %>%
    magick::image_annotate(location = "+5+560",
                           size = 15, color = "white",
                           text = "Made with <3 using R",
                           font = "roboto") %>%
    magick::image_annotate(compliment,
                           location = "+225+100",
                           size = 18, font = "Roboto")

  pretty

}
