library("magrittr")

# get links and tags
sitemap <- xml2::read_xml("https://itsalocke.com/blog/sitemap.xml") %>%
  xml2::as_list() %>%
  .$urlset

# probably re-inventing the wheel
get_one <- function(element, what){
  one <- unlist(element[[what]])
  if(is.null(one)){
    one <- ""
  }

  one
}

# tibble with everything
sitemap <- tibble::tibble(url = purrr::map_chr(sitemap, get_one, "loc"),
                       date = purrr::map_chr(sitemap, get_one, "lastmod"))



# only blog posts
blog <- dplyr::filter(sitemap, !stringr::str_detect(url, "tags\\/"))
blog <- dplyr::filter(blog, !stringr::str_detect(url, "categories\\/"))
blog <- dplyr::filter(blog, !stringr::str_detect(url, "statuses\\/"))
blog <- dplyr::filter(blog, url != "https://itsalocke.com/blog/stuff-i-read-this-week/")
blog <- dplyr::filter(blog, !stringr::str_detect(url, "https://itsalocke.com/blog/.*?\\/.*?\\/"))
blog <- dplyr::filter(blog, url != "https://itsalocke.com/blog/")
blog <- dplyr::filter(blog, url != "https://itsalocke.com/blog/posts/")

# get all yam
gh_info <- dplyr::filter(gh_info, !stringr::str_detect(name, "\\.Rmd"))

# join
# https://github.com/rstudio/blogdown/blob/0c4c30dbfb3ae77b27594685902873d63c2894ad/R/utils.R#L277
dash_filename = function(string, pattern = '[^[:alnum:]^\\.]+') {
  tolower(string) %>%
    stringr::str_replace_all("â", "") %>%
    stringr::str_replace_all("DataOps.*? it.*?s a thing (honest)",
                             "dataops--its-a-thing-honest") %>%
    stringr::str_replace_all(pattern, '-') %>%
    stringr::str_replace_all('^-+|-+$', '')

}
gh_info <- dplyr::mutate(gh_info,
                         base = ifelse(!is.na(slug), slug, title),
                         base = dash_filename(base),
                         false_url = paste0("https://itsalocke.com/blog/",
                                      base, "/"))

all_info <- fuzzyjoin::stringdist_left_join(blog, gh_info,
                                            by = c("url" = "false_url"),
                                            max_dist = 3)
all_info$url[(is.na(all_info$raw))]
