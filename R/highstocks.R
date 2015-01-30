#' A wrapper for Highstock.js graphing library (http://api.highcharts.com/highstock)
#'
#' This function is a wrapper around the Highstock.js library. Currently, this
#' is still an early development version, so there are still quite many glitches.
#'
#' @import htmlwidgets
#'
#' @export
##' @param data A data.frame or data.table object, which must be in a long
##' format. 
##' @param x Name of the x-axis variable. `highstocks` function expects this to be
##' formatted a s a date.
##' @param y Name of the y-axis variable.
##' @param group Name of the group variable. Default is NULL.
##' 
##' @param type Type of graph to be produced. Currently, this wrapper supports
##' only a line option. 
##' @param title Title of the graph.
##' @param xAxis A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
##' @param yAxis A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
##' @param width Width of the graph...
##' @param height Height of the graph...
##' @param chartOpts A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
##' @param creditsOpts A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
##' @param exportingOpts A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
##' @param plotOptions A named list of options to be passed to the Highstock API (see
##' http://api.highcharts.com/highstock for details)
highstocks <- function(
    data = NULL,
    x = NULL,
    y = NULL,
    group = NULL,
    type = 'scatter',
    title = "Test",
    xAxis = list(title = list(text = "Fruit Eaten 1")),
    yAxis = list(title = list(text = "Fruit Eaten 2")),
    width = NULL,
    height = NULL,
    chartOpts = list(),
    creditsOpts = list(),
    exportingOpts = list(),
    plotOptions = list()
){
    if (is.null(data))
        stop("Supply a data argument.")
    if (!inherits(data,'data.frame'))
        stop("`data` must be either a data.frame or a data.table")
    if (is.null(x)|is.null(y))
        stop("`x` and `y` are required.")
    if (is.null(group)){
        group = 'group'
        
        data <- copy(data) %>>%
        mutate(
            group = 1
        )
    }
    
    data %>>%
    select_(
        x,
        y,
        group
    ) %>>%
    rename_(
        x = x,
        y = y,
        group = group
    ) %>>%
    mutate(
        x = (x %>>% as.POSIXct %>>% as.numeric) * 1000 
    ) %>>%    
    .convertDTtoList(
        group = 'group'
    ) ->
        dataList
    
  # forward options using x
  x = list(
      data = dataList,
      title = title,
      chartOpts =
          c(
              chartOpts,
              type = type
          ),
      xAxis = xAxis,
      yAxis = yAxis,
      creditsOpts = creditsOpts,
      exportingOpts = exportingOpts,
      plotOptions = plotOptions     
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'highstocks',
    x,
    width = width,
    height = height,
    package = 'highcharts'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
highstocksOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'highstocks', width, height, package = 'highcharts')
}

#' Widget render function for use in Shiny
#'
#' @export
renderHighstocks <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, highstocksOutput, env, quoted = TRUE)
}

.convertDTtoList <- function(dt, group){
    dt %>>%
    data.table %>>%
    (split(.,f = .[[group]])) %>>%
    list.map({
        list(
            name = .name,
            data = .
        )
    }) ->
        out

    names(out) <- NULL

    return(out)
}


## library(quantmod)
## library(dplyr)
## symbols <- c("MSFT","C","AAPL")

## require(dplyr)


## symbols %>>%
## list.map(
##     get(getSymbols(.))
## ) %>>%
## list.map(
##     . %>>%
##     as.data.frame %>>%
##     mutate(
##         name = .name,
##         date = rownames(.)
##     ) %>>%
##     select(
##         name,
##         date,
##         price = contains("close")
##     ) %>>%
##     data.table    
## ) %>>%
## rbindlist ->
##     data

## dt <- data[name =='AAPL']

## highstocks(
##     data = dt,
##     x = 'date',
##     y = 'price',
##     group = NULL
## )

## highstocks(
##     data = data,
##     x = 'date',
##     y = 'price',
##     group = 'name'
## )



## dt[,qplot(x = date,y = AAPL.Open,geom = 'line')]




## -------------------------------------------------------------------------- ##
## EXAMPLES                                                                   ##
## -------------------------------------------------------------------------- ##
## dataList = list(
##     list(
##         name = 'series1',
##         data = data.frame(
##             x = c(1,2,3,4),
##             y = c(2,3,4,5)
##         )
##     ),
##     list(
##         name = 'series2',
##         data = data.frame(
##             x = c(1,2,3,4),
##             y = c(2,3,4,5)^2
##         )
##     )            
## )

## data = mtcars
## x = 'wt'
## y = 'mpg'
## group = 'cyl'

## highstocks(
##     data = data,
##     x = x,
##     y = y,
##     group = group
## )

## highstocks(
##     dataList = dataList,
##     type  = 'pie',
##     creditsOpts =
##         list(
##             text = "test"
##         )
## )
