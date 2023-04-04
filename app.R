library(shiny)
library(seqinr)
library(stringr)
library(primer3)
library(Biostrings)
library(shinythemes)

options(browser = "qutebrowser")

ui <- fluidPage(
  img(src='logo.png', width = "20%", height = "auto"),
  
  theme = shinytheme("slate"),
  titlePanel("Primer Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Primer Sequence"),
      helpText("Or enter a sequence manually:"),
      textInput("sequence", "🧬 Primer Sequence"),
      br(),
      
      downloadButton("download", "Download Results")
    ),
    mainPanel(
      fluidRow(
        column(width = 6, h4("🔍 GC-Content"), verbatimTextOutput("gc")),
        column(width = 6, h4("🧪 Melting Temperature"), verbatimTextOutput("mt")),
        column(width = 6, h4("🔗 Homodimer"), verbatimTextOutput("hd")),
        column(width = 6, h4("🧷 Harpin Formation"), verbatimTextOutput("hp")),
      ))
      )
    )

server <- function(input, output, session) {

  gccontent <- reactive({
    if (input$sequence != "") {
      seq <- toupper(input$sequence)
      gc <- (str_count(seq, "G|C") / nchar(seq)) * 100
      results <- paste0(round(gc, 3), "%")
      cat(results)
    }
  })
  

  meltingtemp <- reactive({
    if (input$sequence != "") {
      seq <- toupper(input$sequence)
      mt <- calculate_tm(seq)
      results <- paste0(round(mt, 3), "°C")
      cat(results)
    }
  })
  
  hairpin <- reactive({
    if (input$sequence != "") {
      seq <- toupper(input$sequence)
      hp_list <- calculate_hairpin(seq)
      results <- paste0(
      "Hairpin: ", hp_list[1], "\n",
      "Haripin Temp: ", hp_list[2], "\n",
      "ΔS: ", hp_list[3], "\n",
      "ΔH: ", hp_list[4], "\n",
      "ΔG: ", hp_list[5], "\n",
      "Top strand position: ", hp_list[6], "\n",
      "Bottom strand position: ", hp_list[7], "\n")
      cat(results)
    }
  })
  
  homodimer <- reactive({
      if (input$sequence != "") {
        seq <- toupper(input$sequence)
        hd_list <- calculate_homodimer(seq)
        results <- paste0(
          "Hairpin: ", hd_list[1], "\n",
          "Haripin Temp: ", hd_list[2], "\n",
          "ΔS: ", hd_list[3], "\n",
          "ΔH: ", hd_list[4], "\n",
          "ΔG: ", hd_list[5], "\n",
          "Top strand position: ", hd_list[6], "\n",
          "Bottom strand position: ", hd_list[7], "\n")
        cat(results)
      }
    })
  

  observe({
    if (!is.null(input$file)) {
      seq_file <- input$file$datapath
      seq_fasta <- readDNAStringSet(seq_file, format = "fasta")
      seq_chars <- as.character(seq_fasta[[1]])
      updateTextInput(session, "sequence", value = seq_chars)
    }
  })
  
  observeEvent(input$change_theme, {
    updateTheme(session, input$theme)
  })
  
  output$download <- downloadHandler(
    filename = function() {
      paste("primer_results", ".txt", sep = "")
    },
    content = function(file) {
      results <- paste0(gccontent(), "\n", meltingtemp(), "\n", hairpin(), "\n", verbatimTextOutput("hd"))
      write(results, file)
    }
  )
  

  output$gc <- renderPrint({
    gccontent()
  })
  
  output$mt <- renderPrint({
    meltingtemp()
  })
  
  output$hp <- renderPrint({
    hairpin()
  })
  
  output$hd <- renderPrint({
    homodimer()
  })
  
}

# Clear memory
primer3_free()
shinyApp(ui, server)
