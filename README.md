
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pinboardr

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/pinboardr)](https://CRAN.R-project.org/package=pinboardr)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://choosealicense.com/licenses/mit/)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis build
status](https://travis-ci.org/RMHogervorst/pinboardr.svg?branch=master)](https://travis-ci.org/RMHogervorst/pinboardr)
<!-- badges: end -->

The goal of pinboardr is to interact with the
[pinboard.in](https://pinboard.in) website. You can use this package to
add new bookmarks, delete them, extract all bookmarks, or to add, modify
or remove tags. Basically everything you can do through the website, but
from an R session. This is a full implementation of all the endpoints in
<https://pinboard.in/api>.

All user facing functions start with `pb_*` , making it easy to use.

> Pinboard is a personal archive for things you find online and don’t
> want to forget. The site has been around since July 2009 and has about
> 25,000 active users.

If you don’t know what pinboard is, this is not a package for you. If
you would like to know more about pinboard, take [the
tour](https://pinboard.in/tour/).

## Installation

You can install the released version of pinboardr from
[CRAN](https://CRAN.R-project.org) with:

``` r
# install.packages("pinboardr") # not yet
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("RMHogervorst/pinboardr")
```

## Credentials

This is a package to interact with ’<https://pinboard.in>, a payed (not
free) bookmarking website. To use this package you need to use your
username and token from pinboard. See also `?authentication` for more
details.

Go to the [pinboard password
page](https://pinboard.in/settings/password) and scroll down to API
Token. It says something like: "this is your API token:
username:NUMBERSANDLETTERS My recommendation would be to add this token
and username to your local or global .Renvironment file (use for example
`usethis::edit_r_environ()` to find that file on your computer).

    PB_USERNAME=username 
    PB_TOKEN="NUMBERSANDLETTERS"

Restart your session to make the changes active.

## Examples

This part shows you some of the functions implemented in this package.

``` r
library(pinboardr)
```

When was my last update on pinboard?

``` r
pb_last_update()
#> [1] "2020-05-11T08:05:04Z"
```

Get your most recent bookmarks (of a certain tag, or globally)

``` r
recent <- pb_posts_recent(tags = "inspiration",count = 3)
recent[,c("title", "toread","tags")]
#>                                                                                                                                                                                                                                                             title
#> 1                                                                                                                                                                                         The Stars My Destination — nevver: The Dutch Masters, Tussen Kunst &...
#> 2                                                                                                                                                                                                                                Lighting Archives - IKEA Hackers
#> 3 foone on Twitter: "Check out my new keyboard! It's just got 7 switches and a button. You know binary, yeh? Just enter the binary value of the character you want to type, and then push the button. Nothing could be simpler! https://t.co/AmCzHj55dK" / Twitte
#>   toread                           tags
#> 1    yes          inspiration blogNotes
#> 2     no inspiration hardware blogNotes
#> 3     no           inspiration hardware
```

When did I bookmark all my bookmarks?

``` r
library(ggplot2) 
library(dplyr)
per_date <- pb_posts_dates()

per_date %>% 
  mutate(date = as.POSIXct(date)) %>% 
  ggplot(aes(date, count)) + 
  geom_col()+
  labs(title="When did I bookmark?")
```

![](man/figures/bookmarks.png)

Did I read all my bookmarks with the tag inspiration?

``` r
all <- pb_posts_all(tags = "inspiration", todt="2020-01-01")
table(all$toread)
#> 
#>  no yes 
#>  26   9
```

Most common tags with inspiration

``` r
huge_vec <- unlist(strsplit(all$tags, split=" "))
# note that this is way more intuitive with dplyr
# data.frame(vec=huge_vec) %>% group_by(vec) %>% count() %>% arrange(desc(n))
counted <- as.data.frame(table(huge_vec))
top <- counted[counted$Freq >1,]
top[order(top$Freq,decreasing = TRUE),]
#>         huge_vec Freq
#> 12   inspiration   35
#> 27 visualisation   11
#> 2       blogidea    6
#> 18             r    3
#> 11      hardware    2
#> 24         space    2
```

Can we extract all of the bookmarks with the blogidea tag?

``` r
all_blogidea <- pb_add_tag_column(all, "blogidea")
all_blogidea[all_blogidea$blogidea,c("href","title")]
#>                                                                                                    href
#> 5                                               https://vincenttunru.gitlab.io/blog/hacking-a-gameshow/
#> 25                                                                      https://scrollbars.matoseb.com/
#> 30               https://www.williamrchase.com/post/artistic-coding-for-the-user-12-months-of-art-june/
#> 33                                                                  http://tabletopwhale.com/index.html
#> 34 https://www.sciencealert.com/these-incredible-infographics-make-instant-sense-of-our-universe-s-data
#> 35                         https://github.com/Z3tt/satRday2019/blob/master/Scherer_satRday2019_NLMR.pdf
#>                                                                                            title
#> 5  How I spent way too much effort to win a game show on national television · Vincent Tunru.com
#> 25                                                                    Evolution of the Scrollbar
#> 30                            Artistic coding for the useR (12 Months of aRt, June) | Will Chase
#> 33                                                                                Tabletop Whale
#> 34                           This Incredible Orbit Map of Our Solar System Makes Our Brains Ache
#> 35                                                       satRday2019 berlin landscape generation
```

Get all tags used

``` r
all_tags <- pb_tags_get() # will show all 583 tags I have used
head(all_tags, 4)
#>          tag count
#> 1      1960s     1
#> 2         3d     2
#> 3 ab-testing     1
#> 4  abTesting     2
```

Please note that the “pinboardr” project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
