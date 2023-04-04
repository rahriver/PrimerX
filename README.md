# 🧬 PrimerX

This is a simple shiny app to analyze primers using R programming language. The app includes features to analyze GC-content, hairpin formation, homo-dimers, melting temperature (TM), and import files in various formats.

## 🛠️ Installation

To run the app locally, you will need to have R and RStudio installed on your machine.
- [R](https://cran.r-project.org/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/)

You will also need to install the following R packages:

- `shiny`
- `shinythemes`
- `primer3`
- `stringr`
- `Biostrings`
- `seqinr`

> You can install these packages using the Bioconductor installer.

## 💻 Usage

To launch the app, open the `app.R` file in RStudio and click the "Run App" button. This will launch the app in your default web browser.

- `Input`: This tab allows you to input primer sequences and settings for analysis either by pasting the sequence or browsing your file.
- `GC-content`: Shows the GC-content value of your primer.
- `Hairpin Formation`: Shows the potential for hairpin formation in the primer sequence.
- `Homo-dimer`: Shows the potential for homodimerization (self-dimerization) in the primer sequence.
- `Tm`: Melting temperature (TM) for the primer.

To import files, click on the "Browse" button. This will allow you to select and upload files in FASTA or plain text format.

## 🚀 TODO
Include more tabs for further sequence analysis other than just for primers.
- Display self-dimerization
- ClustalW implementation
- Enrichment analysis
- BLAST
