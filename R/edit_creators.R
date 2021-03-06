#' Shiny App for editing the metadata creator table
#'
#' @param filepath the filepath leading to the creators.csv file
#' @param outdir The directory to save the edited creator info to
#' @param outfilename The filename to save with. Defaults to creator.csv.
#' @param numCreators the number of creators that need to be included, defaults to 10
#' @import shiny
#' @import rhandsontable
#' @export
#'
#' @examples
#' \dontrun{
#' editTable(DF = creator)
#'
#'}

edit_creators <- function(filepath="metadata-tables/creators.csv",
                           outdir=getwd(),
                           outfilename="creator",
                         numCreators=10){

ui <- shinyUI(fluidPage(
    titlePanel("Populate the Creators Metadata Table"),
    sidebarLayout(
      sidebarPanel(
        helpText("Shiny app to read in the dataspice metadata templates and populate with usersupplied data"),

        h6('fileName = the name of the input data file(s). Do Not Change.'),
        h6("variableName = the name of the measured variable. Do Not Change."),
        h6('Description = a written description of what that measured variable is'),
        h6("unitText = the units the variable was measured in"),

        br(),

        wellPanel(
          h3("Save table"),
          div(class='row',
              div(class="col-sm-6",
                  actionButton("save", "Save"))
          )
        )

      ),

      mainPanel(
        wellPanel(
          uiOutput("message", inline=TRUE)
        ),
        rHandsontableOutput("hot"),
        br()

      )
    )
  ))

server <- shinyServer(function(input, output) {

  values <- reactiveValues()

  dat <- read_csv(file = filepath,
                  col_types = "ccccc")

  output$hot <- renderRHandsontable({
      rows_to_add <- as.data.frame(matrix(nrow=numCreators,
                                          ncol=ncol(dat)))

      colnames(rows_to_add) <- colnames(dat)
      dat <- dplyr::bind_rows(dat, rows_to_add)
      rhandsontable(dat,
                    useTypes = TRUE,
                    stretchH = "all")
    })

    ## Save
    observeEvent(input$save, {
      finalDF <- hot_to_r(input$hot)
      utils::write.csv(finalDF, file=file.path(outdir,
                                        sprintf("%s.csv", outfilename)),
                row.names = FALSE)
    })

    ## Message
    output$message <- renderUI({
      if(input$save==0){
        helpText(sprintf("This table will be saved in folder \"%s\" once you press the Save button.", outdir))
      }else{
        outfile <- "creator.csv"
        fun <- 'read.csv'
        list(helpText(sprintf("File saved: \"%s\".",
                              file.path(outdir, outfile))),
             helpText(sprintf("Type %s(\"%s\") to get it.",
                              fun, outfile)))
      }
    })

  })

  ## run app
  runApp(list(ui=ui, server=server))
  return(invisible())
}
