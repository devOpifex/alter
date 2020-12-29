# alter

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/devOpifex/alter.svg?branch=master)](https://travis-ci.com/devOpifex/alter)
<!-- badges: end -->

Interface to the [DataSet](https://github.com/antvis/data-set) library by AntV. This is mainly for use in [AntV](https://antv.vision/en/) visualisation libraries; this is built for [g2r](https://github.com/devOpifex/g2r).

## Installation

You can install the package from Github.

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/alter")
```

## Examples

```r
library(alter)

alter(
  cars, 
  sizeByCount = TRUE, 
  type = "bin.hexagon", 
  fields = c("speed", "dist"), 
  bins = c(10, 5)
)

alter(
 cars, 
 type = "aggregate", 
 fields = c("speed", "dist"), 
 operations = c("mean", "mean"), 
 as = c("x", "y")
) 
```
