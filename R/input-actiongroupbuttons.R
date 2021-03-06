#' @title Actions Buttons Group Inputs
#'
#' @description
#' Create a group of actions buttons.
#'
#' @param inputIds The \code{input}s slot that will be used to access the value, one for each button.
#' @param labels Labels for each buttons, must have same length as \code{inputIds}.
#' @param status Add a class to the buttons, you can use Bootstrap status like 'info', 'primary', 'danger', 'warning' or 'success'.
#'  Or use an arbitrary strings to add a custom class, e.g. : with \code{status = 'myClass'}, buttons will have class \code{btn-myClass}.
#' @param size Size of the buttons ('xs', 'sm', 'normal', 'lg').
#' @param direction Horizontal or vertical.
#' @param fullwidth If TRUE, fill the width of the parent div.
#' @return An actions buttons group control that can be added to a UI definition.
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools tags
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' if (interactive()) {
#'   library("shiny")
#'   library("shinyWidgets")
#'
#'   ui <- fluidPage(
#'     br(),
#'     actionGroupButtons(
#'       inputIds = c("btn1", "btn2", "btn3"),
#'       labels = list("Action 1", "Action 2", tags$span(icon("gear"), "Action 3")),
#'       status = "primary"
#'     ),
#'     verbatimTextOutput(outputId = "res1"),
#'     verbatimTextOutput(outputId = "res2"),
#'     verbatimTextOutput(outputId = "res3")
#'   )
#'
#'   server <- function(input, output, session) {
#'
#'     output$res1 <- renderPrint(input$btn1)
#'
#'     output$res2 <- renderPrint(input$btn2)
#'
#'     output$res3 <- renderPrint(input$btn3)
#'
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
#' }
#'
actionGroupButtons <- function(inputIds,
                               labels,
                               status = "default",
                               size = "normal",
                               direction = "horizontal",
                               fullwidth = FALSE) {
  stopifnot(length(inputIds) == length(labels))
  size <-
    match.arg(arg = size,
              choices = c("xs", "sm", "normal", "lg"))
  direction <-
    match.arg(arg = direction,
              choices = c("horizontal", "vertical"))
  if (size == "normal") {
    if (direction == "horizontal") {
      div_class <- "btn-group"
      if (fullwidth) {
        div_class <- paste(div_class, "btn-group-justified")
      }
    } else {
      div_class <- "btn-group-vertical"
    }
  } else {
    if (direction == "horizontal") {
      div_class <- paste0("btn-group btn-group-", size)
      if (fullwidth) {
        div_class <- paste(div_class, "btn-group-justified")
      }
    } else {
      div_class <- paste0("btn-group-vertical btn-group-", size)
    }
  }
  htmltools::tags$div(
    class = div_class,
    role = "group",
    lapply(
      X = seq_along(labels),
      FUN = function(i) {
        value <- shiny::restoreInput(id = inputIds[i], default = NULL)
        tags$div(
          class = "btn-group",
          role = "group",
          htmltools::tags$button(
            id = inputIds[i],
            type = "button",`data-val` = value,
            class = paste0("btn action-button btn-", status),
            labels[i]
          )
        )
      }
    )
  )
}
