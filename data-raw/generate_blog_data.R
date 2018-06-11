source("data-raw/code/get_gh_posts_info.R")
source("data-raw/code/get_all_posts.R")
lockedata_blog <- all_info
lockedata_blog <- dplyr::mutate(lockedata_blog,
                         title = stringr::str_replace_all(title, "â€¦", "!"),
                         title = stringr::str_replace_all(title, "â€“", "-"),
                         title = stringr::str_replace_all(title, "â€™", "'"))

usethis::use_data(lockedata_blog, overwrite = TRUE)
