#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(rmarkdown)
library(knitr)
library(tinytex)
library(rsconnect)
# TODO add system fonts
fonts = c(
  "Default" = "",
  "Al Bayan",
  "American Typewriter",
  "Andalé Mono",
  "Apple Casual",
  "Apple Chancery",
  "Apple Garamond",
  "Apple Gothic",
  "Apple LiGothic",
  "Apple LiSung",
  "Apple Myungjo",
  "Apple Symbols",
  "Arial",
  "Arial Hebrew",
  "Ayuthaya",
  "Baghdad",
  "Baskerville",
  "Beijing",
  "BiauKai",
  "Big Caslon",
  "Brush Script",
  "Chalkboard",
  "Chalkduster",
  "Charcoal",
  "Charcoal CY",
  "Chicago",
  "Cochin",
  "Comic Sans",
  "Cooper",
  "Copperplate",
  "Corsiva Hebrew",
  "Courier",
  "Courier New",
  "DecoType Naskh",
  "Devanagari",
  "Didot",
  "Euphemia UCAS",
  "Futura",
  "Gadget",
  "Geeza Pro",
  "Geezah",
  "Geneva",
  "Geneva CY",
  "Georgia",
  "Gill Sans",
  "Gujarati",
  "Gung Seoche",
  "Gurmukhi",
  "Hangangche",
  "HeadlineA",
  "Hei",
  "Helvetica",
  "Helvetica CY",
  "Helvetica Neue",
  "Herculanum",
  "Hiragino Kaku Gothic Pro",
  "Hiragino Kaku Gothic ProN",
  "Hiragino Kaku Gothic Std",
  "Hiragino Kaku Gothic StdN",
  "Hiragino Maru Gothic Pro",
  "Hiragino Maru Gothic ProN",
  "Hiragino Mincho Pro",
  "Hiragino Mincho ProN",
  "Hoefler Text",
  "Inai Mathi",
  "Impact",
  "Jung Gothic",
  "Kai",
  "Keyboard",
  "Krungthep",
  "KufiStandard GK",
  "LastResort",
  "LiHei Pro",
  "LiSong Pro",
  "Lucida Grande",
  "Marker Felt",
  "Menlo",
  "Monaco",
  "Monaco CY",
  "Mshtakan",
  "Nadeem",
  "New Peninim",
  "New York",
  "NISC GB18030",
  "Optima",
  "Osaka",
  "Palatino",
  "Papyrus",
  "PC Myungjo",
  "Pilgiche",
  "Plantagenet Cherokee",
  "Raanana",
  "Sand",
  "Sathu",
  "Seoul",
  "Shin Myungjo Neue",
  "Silom",
  "Skia",
  "Song",
  "ST FangSong",
  "ST Heiti",
  "ST Kaiti",
  "ST Song",
  "Symbol",
  "Tae Graphic",
  "Tahoma",
  "Taipei",
  "Techno",
  "Textile",
  "Thonburi",
  "Times",
  "Times CY",
  "Times New Roman",
  "Trebuchet MS",
  "Verdana",
  "Zapf Chancery",
  "Zapf Dingbats",
  "Zapfino"
)

# Define UI for application
ui <- navbarPage(
  theme = shinytheme("united"),
  title = 'typAdemic',
  tabPanel("write!",
           sidebarLayout(
             sidebarPanel(
               h3("Uploads"),
               fileInput(
                 'md_file',
                 "Select Markdown files",
                 multiple = FALSE,
                 accept = c("text/plain",
                            "text/markdown",
                            ".txt",
                            ".md",
                            ".markdown"),
                 width = NULL,
                 buttonLabel = "Browse...",
                 placeholder = "No file selected"
               ),
               fileInput(
                 'zip_file',
                 "Select images (must be zip a zip archive)",
                 multiple = FALSE,
                 accept = c("application/zip", ".zip"),
                 width = NULL,
                 buttonLabel = "Browse...",
                 placeholder = "No file selected"
               ),
               fileInput(
                 'bib_file',
                 'Select BibTex or BibLaTex files',
                 multiple = FALSE,
                 accept = c(
                   "text/plain",
                   "application/x-bibtex",
                   ".bib",
                   ".bibtex",
                   ".biblatex"
                 ),
                 width = NULL,
                 buttonLabel = "Browse...",
                 placeholder = "No file selected"
               ),
               h3("Export"),
               radioButtons('format', 'Document format', c('PDF', 'Word', 'LaTeX'),
                            inline = TRUE),
               downloadButton('downloadReport')
               
             ),
             mainPanel(
               tabsetPanel(
                 type = "tabs",
                 # tabPanel(
                 #   "Content",
                 #   aceEditor('editor_content', "# Some title", mode="markdown",
                 #             theme="chrome", autoComplete="enabled")
                 # ),
                 tabPanel(
                   "General information",
                   selectInput(
                     'documentclass',
                     'Documentclass',
                     c(
                       # "Article" = "article",
                       # "Report" = "report",
                       # "Book" = "book"
                       # # TODO replace with Koma Script
                       "Article" = "scrartcl",
                       "Report" = "scrreprt",
                       "Book" = "scrbook"
                     ),
                     multiple = FALSE
                   ),
                   selectInput(
                     'lang',
                     'Language',
                     c(
                       "German" = "de",
                       "English" = "en",
                       "French" = "fr",
                       "Italian" = "it"
                     ),
                     multiple = FALSE
                   ),
                   textInput('author', 'Author(s)', placeholder = "separate multiple authors by comma"),
                   textInput('title', 'Title'),
                   textInput('subtitle', 'Subtitle', placeholder = "For reports and books only"),
                   textAreaInput('abstract', 'Abstract', placeholder = "For articles and reports only"),
                   textAreaInput('thanks', 'Thanks', placeholder = "For articles and reports only"),
                   textInput('keywords', 'Keywords', placeholder = "separate multiple keywords by comma"),
                   textInput('date', 'Publication date', placeholder = "2018-12-31 (or any other format)"),
                   selectInput(
                     'csl',
                     'Citation Style',
                     c(
                       "infoclio-de.csl",
                       "infoclio-fr-nocaps.csl",
                       "infoclio-fr-smallcaps.csl",
                       "apa-5th-edition.csl",
                       "apa-6th-edition.csl",
                       "chicago-17th-edition-author-date.csl",
                       "chicago-17th-edition-fullnote-bibliography.csl",
                       "chicago-17th-edition-note-bibliography.csl",
                       "universitat-freiburg-geschichte.csl"
                     ),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   )
                 ),
                 tabPanel(
                   "Indexes",
                   selectInput(
                     'toc',
                     'Add table of contents',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'toc_depth',
                     'Select table of contents depth',
                     c("3",
                       "1",
                       "2",
                       "4"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'lof',
                     'Add list of figures',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'lot',
                     'Add list of tables',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   )
                 ),
                 tabPanel(
                   "Figures",
                   selectInput(
                     'fig_caption',
                     'Add captions to figures',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'fig_crop',
                     'Crop figures',
                     c("no",
                       "yes"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'fig_height',
                     'Resize figure (height)',
                     c(
                       "no default height" = "",
                       "1cm" = "0.3937008",
                       "1.5cm" = "0.5905512",
                       "2cm" = "0.7874016",
                       "2.5cm" = "0.984252",
                       "3cm" = "1.181102",
                       "3.5cm" = "1.377953",
                       "4cm" = "1.574803",
                       "4.5cm" = "1.771654",
                       "5cm" = "1.968504",
                       "5.5cm" = "2.165354",
                       "6cm" = "2.362205",
                       "6.5cm" = "2.559055",
                       "7cm" = "2.755906",
                       "7.5cm" = "2.952756",
                       "8cm" = "3.149606",
                       "8.5cm" = "3.346457",
                       "9cm" = "3.543307",
                       "9.5cm" = "3.740157",
                       "10cm" = "3.937008",
                       "10.5cm" = "4.133858",
                       "11cm" = "4.330709",
                       "11.5cm" = "4.527559",
                       "12cm" = "4.724409",
                       "12.5cm" = "4.92126",
                       "13cm" = "5.11811",
                       "13.5cm" = "5.314961",
                       "14cm" = "5.511811",
                       "14.5cm" = "5.708661",
                       "15cm" = "5.905512",
                       "15.5cm" = "6.102362",
                       "16cm" = "6.299213",
                       "16.5cm" = "6.496063",
                       "17cm" = "6.692913",
                       "17.5cm" = "6.889764",
                       "18cm" = "7.086614",
                       "18.5cm" = "7.283465",
                       "19cm" = "7.480315",
                       "19.5cm" = "7.677165",
                       "20cm" = "7.874016"
                     ),
                     multiple = FALSE
                   ),
                   selectInput(
                     'fig_width',
                     'Resize figure (width)',
                     c(
                       "no default height" = "",
                       "1cm" = "0.3937008",
                       "1.5cm" = "0.5905512",
                       "2cm" = "0.7874016",
                       "2.5cm" = "0.984252",
                       "3cm" = "1.181102",
                       "3.5cm" = "1.377953",
                       "4cm" = "1.574803",
                       "4.5cm" = "1.771654",
                       "5cm" = "1.968504",
                       "5.5cm" = "2.165354",
                       "6cm" = "2.362205",
                       "6.5cm" = "2.559055",
                       "7cm" = "2.755906",
                       "7.5cm" = "2.952756",
                       "8cm" = "3.149606",
                       "8.5cm" = "3.346457",
                       "9cm" = "3.543307",
                       "9.5cm" = "3.740157",
                       "10cm" = "3.937008",
                       "10.5cm" = "4.133858",
                       "11cm" = "4.330709",
                       "11.5cm" = "4.527559",
                       "12cm" = "4.724409",
                       "12.5cm" = "4.92126",
                       "13cm" = "5.11811",
                       "13.5cm" = "5.314961",
                       "14cm" = "5.511811",
                       "14.5cm" = "5.708661",
                       "15cm" = "5.905512",
                       "15.5cm" = "6.102362",
                       "16cm" = "6.299213",
                       "16.5cm" = "6.496063",
                       "17cm" = "6.692913",
                       "17.5cm" = "6.889764",
                       "18cm" = "7.086614",
                       "18.5cm" = "7.283465",
                       "19cm" = "7.480315",
                       "19.5cm" = "7.677165",
                       "20cm" = "7.874016"
                     ),
                     multiple = FALSE
                   )
                 ),
                 tabPanel(
                   "Page settings",
                   selectInput(
                     'papersize',
                     'Papersize',
                     c("DIN A4" = "a4",
                       "DIN A5" = "a5"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'margin_left',
                     'Margin left',
                     c(
                       "3 cm" = "3cm",
                       "2.5 cm" = "2.5cm",
                       "2 cm" = "2cm",
                       "1.5 cm" = "1.5cm",
                       "1 cm" = "1cm",
                       "3.5 cm" = "3.5cm",
                       "4 cm" = "4cm"
                     ),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'margin_right',
                     'Margin right',
                     c(
                       "3 cm" = "3cm",
                       "2.5 cm" = "2.5cm",
                       "2 cm" = "2cm",
                       "1.5 cm" = "1.5cm",
                       "1 cm" = "1cm",
                       "3.5 cm" = "3.5cm",
                       "4 cm" = "4cm"
                     ),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'margin_top',
                     'Margin top',
                     c(
                       "3 cm" = "3cm",
                       "2.5 cm" = "2.5cm",
                       "2 cm" = "2cm",
                       "1.5 cm" = "1.5cm",
                       "1 cm" = "1cm",
                       "3.5 cm" = "3.5cm",
                       "4 cm" = "4cm"
                     ),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'margin_bottom',
                     'Margin bottom',
                     c(
                       "3 cm" = "3cm",
                       "2.5 cm" = "2.5cm",
                       "2 cm" = "2cm",
                       "1.5 cm" = "1.5cm",
                       "1 cm" = "1cm",
                       "3.5 cm" = "3.5cm",
                       "4 cm" = "4cm"
                     ),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   )
                 ),
                 tabPanel(
                   "Font settings",
                   # mainfontoption:
                   # sansfontoption:
                   # monofontoption:
                   # mathfontoption:
                   # microtypeoptions:
                   selectInput(
                     'mainfont',
                     'Mainfont',
                     fonts,
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'sansfont',
                     'Sansfont',
                     fonts,
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'monofont',
                     'Monofont',
                     fonts,
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'mainfont',
                     'Mainfont',
                     fonts,
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'mathfont',
                     'Mathfont',
                     fonts,
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'fontsize',
                     'Fontsize',
                     c("11pt", "8pt", "9pt", "10pt", "12pt", "13pt", "14pt"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'linestretch',
                     'Linestretch',
                     c("1.5", "1.25", "1", "1.75", "2"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'link_citations',
                     'Link citations',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'colorlinks',
                     'Colored links',
                     c("yes",
                       "no"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'citecolor',
                     'Citation link color',
                     c("black", "red", "green", "magenta", "cyan", "blue"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'toccolor',
                     'Table of contents link color',
                     c("black", "red", "green", "magenta", "cyan", "blue"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'urlcolor',
                     'URL color',
                     c("black", "red", "green", "magenta", "cyan", "blue"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   selectInput(
                     'linkcolor',
                     'Cross reference color',
                     c("black", "red", "green", "magenta", "cyan", "blue"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   )
                 ),
                 tabPanel(
                   "Advanced settings",
                   
                   selectInput(
                     'endnote-conversion',
                     'Convert EndNote style citations',
                     c("black", "red", "green", "magenta", "cyan", "blue"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   p(
                     "EndNote citations {Sarasin, 2012, #344} can be automatically converted."
                   ),
                   selectInput(
                     'links_as_notes',
                     'Links as notes',
                     c("no",
                       "yes"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   p("URLs can be added as foot notes."),
                   selectInput(
                     'highlight',
                     'Highlight programming code',
                     c("tango", "pygments", "kate", "zenburn"),
                     multiple = FALSE,
                     selectize = TRUE,
                     width = NULL,
                     size = NULL
                   ),
                   p("Several styles for programming code highlight are available.")
                 )
               )
             )
           )),
  tabPanel(
    "about!",
    h1("About"),
    p("we are still in a very early alpha stage!")
  )
)




# Define server logic
server <- function(input, output) {
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('typademic-export', sep = '.', switch(
        input$format,
        PDF = 'pdf',
        Word = 'docx',
        LaTeX = 'tex'
      ))
    },
    
    content = function(file) {
      if (toString(input$zip_file$datapath) != "") {
        unzip(
          toString(input$zip_file$datapath),
          files = NULL,
          list = FALSE,
          overwrite = TRUE,
          junkpaths = FALSE,
          exdir = 'tmp',
          unzip = "internal",
          setTimes = FALSE
        )
      }
      
      # TODO change from knitr to pandocconvert for safety reasons
      tmpfile <- tempfile(tmpdir = 'tmp', fileext = ".Rmd")
      fileConn <- file(tmpfile)
      writeLines(
        c(
          "---",
          "output:",
          paste(" ", switch(
            input$format,
            PDF = "pdf_document:",
            Word = "word_document:",
            LaTeX = "tex_document:"
          )),
          "    latex_engine: xelatex",
          "    keep_tex: yes",
          "    template: ../latex/default-1.17.0.2.tex",
          "    pandoc: null",
          paste("    highlight:", toString(input$highlight)),
          paste("    fig_caption:", toString(input$fig_caption)),
          "header-includes:",
          # "  - \\usepackage[ngerman]{babel}",
          "  - \\flushbottom",
          "  - \\clubpenalty10000",
          "  - \\widowpenalty10000",
          "  - \\displaywidowpenalty=10000",
          "  - \\interfootnotelinepenalty=10000",
          "  - \\setkomafont{sectioning}{}",
          paste("documentclass:", toString(input$documentclass)),
          paste("lang:", toString(input$lang)),
          paste("author:", toString(input$author)),
          paste("title:", toString(input$title)),
          ifelse(
            input$documentclass == "scrbook",
            paste("subtitle:", toString(input$subtitle)),
            ""
          ),
          ifelse(
            input$documentclass != "scrbook",
            paste("abstract:", toString(input$abstract)),
            ""
          ),
          ifelse(
            input$documentclass != "scrbook",
            paste("thanks:", toString(input$thanks)),
            ""
          ),
          paste("keywords:", toString(input$keywords)),
          paste("date:", toString(input$date)),
          paste("csl: ../csl/", toString(input$csl), sep = ""),
          paste("bibliography:", toString(input$bib_file$datapath)),
          paste("toc:", toString(input$toc)),
          paste("toc_depth:", toString(input$toc_depth)),
          paste("lof:", toString(input$lof)),
          paste("fig_crop:", toString(input$fig_crop)),
          paste("fig_height:", toString(input$fig_height)),
          paste("fig_width:", toString(input$fig_width)),
          paste("lot:", toString(input$lot)),
          paste("papersize:", toString(input$papersize)),
          paste("margin-left:", toString(input$margin_left)),
          paste("margin-right:", toString(input$margin_right)),
          paste("margin-top:", toString(input$margin_top)),
          paste("margin-bottom:", toString(input$margin_bottom)),
          paste("mainfont:", toString(input$mainfont)),
          paste("sansfont:", toString(input$sansfont)),
          paste("monofont:", toString(input$monofont)),
          paste("mathfont:", toString(input$mathfont)),
          # ifelse(
          #   input$documentclass != "scrbook",
          #   paste("thanks:", toString(input$thanks)),
          #   ""
          # ),
          paste("fontsize:", toString(input$fontsize)),
          paste("linestretch:", toString(input$linestretch)),
          paste("link-citations:", toString(input$link_citations)),
          paste("colorlinks:", toString(input$colorlinks)),
          paste("toccolor:", toString(input$toccolor)),
          paste("citecolor:", toString(input$citecolor)),
          paste("urlcolor:", toString(input$urlcolor)),
          paste("linkcolor:", toString(input$linkcolor)),
          paste("links-as-notes:", toString(input$links_as_notes)),
          "---",
          "```{r, echo=FALSE}",
          "htmltools::includeHTML(input$md_file$datapath)",
          "```"
        ),
        fileConn
      )
      close(fileConn)
      out <- render(tmpfile)
      file.rename(out, file)
      # TODO service worker which cleans the temp dir every night
      # unlink('tmp', recursive = TRUE, force = FALSE)
    }
  )
}


# Run the application
shinyApp(ui = ui, server = server)
