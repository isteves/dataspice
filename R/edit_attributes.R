#' Shiny App for editing the metadata attributes table
#'
#' @param filepath the filepath leading to the attributes.csv file
#' @param outdir The directory to save the edited attributes info to
#' @param outfilename The filename to save with. Defaults to attributes.csv.
#'
#' @export
#' @import shiny
#' @import rhandsontable

#'
#' @examples
#' \dontrun{
#' editTable(DF = attributes)
#'
#'}

edit_attributes <- function(filepath="metadata-tables/attributes.csv",
                      outdir=getwd(),
                      outfilename="attributes"){
  ui <- shinyUI(fluidPage(

    titlePanel("Populate the Attributes Metadata Table"),
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
                    col_types = "cccc")
    
    output$hot <- renderRHandsontable({
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
        outfile <- "attributes.csv"
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
