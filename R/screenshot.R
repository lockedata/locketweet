
#'
#' Webshot regions of a blog post
#'
#' @param df A data.frame with post_name, header and number variables.
#' @param path Either a full or partial path, where to put the screenshots.
#'
#' @return Nothing, it does produce screenshots in the path,
#' using the post_name and numbers to name files.
#' @export
#'
#' @examples
shot_region <- function(df, path){
  # extract information from the data.frame
  header <- df$header
  number <- df$number
  url <- df$url
  post_name <- df$post_name
  # this is the title
  if (header == ""){
    filename <- paste0(path, "/", post_name,
                       number,
                       "-title",".png")
    webshot::webshot(url = url,
                     selector = "p",
                     file = "webshot.png",
                     expand = c(5, 5, 200, 5))
  }else{ #these are other regions
    filename <- paste0(path, "/", post_name,
                       number, "-",
                       header,".png")
    webshot::webshot(url = url,
                     file = "webshot.png",
                     selector = paste0("#", header),
                     expand = c(5, 5, 200, 5))
  }
  # add border to files
  magick::image_read("webshot.png") %>%
    #magick::image_border(color = "#E8830C", geometry = "10x10") %>%
    magick::image_border(color = "#2165B6", geometry = "30x30") %>%
    magick::image_write(filename)

  # cleans after itself
  file.remove("webshot.png")
}


#' Get headers information from a blogpost
#'
#' @param post_df a one line data.frame a post name,
#' its url.
#'
#' @return A tibble with the blog post name and url and for each
#' section its header and a number, from 0 (title) to the number
#' of headers
#' @export
#'
#' @examples
get_post_info <- function(post_df){
  url <- post_df$url[1]
  post_name <- stringr::str_replace(post_df$name[1],
                                    "\\.md", "")

  headers <-  httr::GET(url) %>%
    httr::content() %>%
    rvest::html_nodes("h2") %>%
    rvest::html_attrs() %>%
    unlist()

  tibble::tibble(url = url,
                 post_name = post_name,
                 header = c("", headers),
                 number = seq_along(header))
}
