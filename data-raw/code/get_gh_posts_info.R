library("magrittr")
# https://stackoverflow.com/questions/25022016/get-all-file-names-from-a-github-repo-through-the-github-api

# get link to all posts and their filename
posts <- gh::gh("/repos/:owner/:repo/contents/:path",
                owner = "lockedatapublished",
                repo = "blog",
                path = "content/posts")

gh_posts <- tibble::tibble(name = vapply(posts, "[[", "", "name"),
                           path = vapply(posts, "[[", "", "path"),
                           raw = vapply(posts, "[[", "", "download_url"))
gh_posts <- gh_posts[gh_posts$name != ".DS_Store",]
# get links to pics posted in each post
get_pics <- function(path){
    message(path)
    file <- gh::gh("/repos/:owner/:repo/contents/:path",
                   owner = "lockedatapublished",
                   repo = "blog",
                   path = path)
    content <- rawToChar(base64enc::base64decode(file$content))
    # get links to imgs
    img <- stringr::str_match(content, 'src=\\\".*?\\/img\\/(.*?)\"' )[,2]
    tibble::tibble(path = path,
                   img = img)
}

pics <- purrr::map_df(gh_posts$path, get_pics)
gh_pics <- dplyr::left_join(gh_posts, pics, by = "path")
gh_pics <- dplyr::filter(gh_pics, !is.na(img))

# now get all tags and categories
get_one_yaml <- function(path){
  print(path)
  file <- gh::gh("/repos/:owner/:repo/contents/:path",
                 owner = "lockedatapublished",
                 repo = "blog",
                 path = path)
  content <- rawToChar(base64enc::base64decode(file$content))

  # the yaml function didn't like this
  content <- stringr::str_replace_all(content, "â€œ", "")
  content <- stringr::str_replace_all(content, "â€\u009d", "")
  content <- stringr::str_replace_all(content, "#9D", "")
  content <- stringr::str_replace_all(content, "&", "")
  write(content, "temporary.md")
  data <- rmarkdown::yaml_front_matter("temporary.md")
  file.remove("temporary.md")

  # is this an elegant solution? NO!!!
  # but this way I'll get both categories and tags
  # and won't get issues if several categories/tags
  categories <- data$categories
  data$categories <- NULL
  data <- dplyr::as_data_frame(data)


  if("tags" %in% names(data)){

    data <- dplyr::mutate(data, value = TRUE)
    data <- tidyr::spread(data, tags, value, fill = FALSE)
    data <- dplyr::mutate(data, path = path)
  }


  if(!is.null(categories)){
    categories <- dplyr::tibble(categories = paste0("cat_", categories))
    categories <- dplyr::mutate(categories, value = TRUE)
    categories <- tidyr::spread(categories, categories, value, fill = FALSE)
  }

  data <- cbind(data, categories)
  data
}

info <- purrr::map_df(gh_posts$path, get_one_yaml)
gh_posts <- dplyr::left_join(gh_posts, info, by = "path")
gh_info <- gh_posts
gh_info <- dplyr::mutate(gh_info,
                         title = stringr::str_replace_all(title, "â€¦", "!"),
                         title = stringr::str_replace_all(title, "â€“", "-"),
                         title = stringr::str_replace_all(title, "â€™", "'"))
