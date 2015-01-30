# highchartR

This is an early development version of the highchartR library, which is a
htmlwidget wrapper around Highcharts and Highstock javascript graphing
libraries (http://www.highcharts.com/demo).

### Installation
The package is currently not available at CRAN, so you need **devtools** package
for the installation. You can install the package as follows:

```R
devtools::install_github('jcizel/highchartR')
```

There are two functions in the package that do most of the work: **highcharts**,
which acts as a wrapper around the **Highcharts** library
(http://api.highcharts.com/highcharts), and **highstocks** wraps the **Highstock** library
(http://api.highcharts.com/highstock).

### Examples
To be expanded..
#### Highcharts
```R
data = mtcars
x = 'wt'
y = 'mpg'
group = 'cyl'

highcharts(
    data = data,
    x = x,
    y = y,
    group = group,
	type = 'scatter'
)
```

#### Highstock
```R
library(data.table)
library(pipeR)
library(rlist)
library(quantmod)
library(dplyr)

symbols <- c("MSFT","C","AAPL")

symbols %>>%
list.map(
    get(getSymbols(.))
) %>>%
list.map(
    . %>>%
    as.data.frame %>>%
    mutate(
        name = .name,
        date = rownames(.)
    ) %>>%
    select(
        name,
        date,
        price = contains("close")
    ) %>>%
    data.table  
) %>>%
rbindlist ->
    data

highstocks(
    data = data,
    x = 'date',
    y = 'price',
    group = 'name'
)

```
