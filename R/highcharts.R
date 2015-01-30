n#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
##' @param data 
##' @param x 
##' @param y 
##' @param group 
##' @param type 
##' @param title 
##' @param xAxis 
##' @param yAxis 
##' @param width 
##' @param height 
##' @param chartOpts 
##' @param creditsOpts 
##' @param exportingOpts 
##' @param plotOptions 
##' @param dataList A list of data.tables, one for each series to be plotted. 
highcharts <- function(
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
        
        data %>>%
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
    name = 'highcharts',
    x,
    width = width,
    height = height,
    package = 'highcharts'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
highchartsOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'highcharts', width, height, package = 'highcharts')
}

#' Widget render function for use in Shiny
#'
#' @export
renderHighcharts <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, highchartsOutput, env, quoted = TRUE)
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

data = mtcars
x = 'wt'
y = 'mpg'
group = 'cyl'

highcharts(
    data = data,
    x = x,
    y = y,
    group = group
)

## highcharts(
##     dataList = dataList,
##     type  = 'pie',
##     creditsOpts =
##         list(
##             text = "www.jankocizel.com"
##         )
## )
