
<!-- README.md is generated from README.Rmd. Please edit that file -->
locketweet
==========

The goal of locketweet is to help us get a collection of screenshots without too much effort.

Installation
------------

You can install locketweet from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("lockedata/locketweet")
```

Examples
--------

See [this blog post](https://itsalocke.com/blog/how-to-maraaverickfy-a-blog-post-without-even-reading-it/) for more background info.

``` r
library("locketweet")
webshot_prettyplease(url = "https://itsalocke.com/blog/auto-deploying-documentation-better-change-tracking-of-artefacts/",
                     path = "README_files/example1.png")
#> now webshooting!
#> now prettifying!
```

![](README_files/example1.png)

``` r
webshot_prettyplease(url = "https://itsalocke.com/blog/how-to-maraaverickfy-a-blog-post-without-even-reading-it/",
                     path = "README_files/example2.png")
#> now webshooting!
#> now prettifying!
```

![](README_files/example2.png)
