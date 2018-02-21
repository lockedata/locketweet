
<!-- README.md is generated from README.Rmd. Please edit that file -->
locketweet
==========

The goal of locketweet is to ...

Installation
------------

You can install locketweet from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("lockedata/locketweet")
```

Example
-------

See [this blog post](https://itsalocke.com/blog/how-to-maraaverickfy-a-blog-post-without-even-reading-it/) for more background info.

The data about the blog is now generated in data-raw and available as data from the package!

``` r
library("magrittr")
library("locketweet")
data("lockedata_blog")
class(lockedata_blog)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

So we can generate screenshots using it. I'll be selfish and use my blog post as example!

``` r


height <- 1000
width <- 300

fs::dir_create("screenshots")
get_post_info(lockedata_blog[1,]) %>%
  dplyr::filter(number > 1) %>%
  split(.$header) %>%
  purrr::walk(shot_region, path = "screenshots")  
```

``` r
imgs <- fs::dir_ls("screenshots")
col_no <- ceiling(length(imgs)/2)
if(length(imgs) != col_no*2) {
  img1 <- magick::image_blank(height, width, color = "#2165B6") 
}else{
  img1 <- NULL
}

imgs <- magick::image_read(imgs) %>%
  magick::image_resize(geometry = paste0(height, "x", width))

col1 <- magick::image_append(imgs[1:ceiling(length(imgs)/2)],
                             stack = TRUE)
col2 <- magick::image_append(imgs[(ceiling(length(imgs)/2) + 1): length(imgs)],
                             stack = TRUE)
if(!is.null(img1)){
  col2 <- magick::image_append(c(col2, img1), stack = TRUE)
}

all <- magick::image_append(c(col1, col2))
title <- magick::image_blank(height * 2, 50, color = "#2165B6")
title <- magick::image_annotate(title, lockedata_blog$title[1], size = 50)
all <- magick::image_append(c(title, all), stack = TRUE)
chibi <- magick::image_read(system.file("extdata/assets", "HappyDataScienceSteffy_preview.png", package = "locketweet")) %>%
  magick::image_resize(paste0(width, "x", width))
magick::image_mosaic(c(all, chibi)) 
```

<img src="C:\Users\Maelle\AppData\Local\Temp\Rtmp0G939u\file10802e0612fb.png" width="100%" />

``` r
fs::dir_delete("screenshots")
```
