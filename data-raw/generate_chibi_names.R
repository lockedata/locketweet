chibi_names <- fs::dir_ls("inst/extdata/assets")
chibi_names <- stringr::str_replace(chibi_names, "inst\\/extdata\\/assets\\/", "")
chibi_names <- chibi_names[chibi_names != "logo.png"]
chibis <- tibble::tibble(chibi = chibi_names)
chibis <- dplyr::group_by(chibis, chibi)
chibis <- dplyr::mutate(chibis,
                        person = stringr::str_split(chibi, "_")[[1]][2],
                        person = stringr::str_replace(person, "\\.png", ""))
chibis <- dplyr::ungroup(chibis)
usethis::use_data(chibis, overwrite = TRUE)
