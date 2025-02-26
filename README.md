# NID Dam Data Shiny App

This repository contains the code and data for a Shiny app that visualizes dam data from the National Inventory of Dams (NID).

## Files

* `app.R`: The Shiny app code.
* `data/NID_data.csv`: The NID data as of 2/26/2025

## How to Run

To run this app locally, you'll need R and RStudio installed. Follow these steps:

1.  Clone this repository to your local machine.
2.  Open RStudio.
3.  Set the working directory to the cloned repository folder.
4.  Install the required R packages: `shiny`, `leaflet`, `maps`, `dplyr`, `ggplot2`, and `scales`.
5.  Run the app using `shiny::runApp("app.R")`.

## Deployment

This app cannot be directly hosted on GitHub Pages because it requires a server-side R process. Instead it can be accessed here:
* [ShinyProxy](https://www.shinyproxy.io/)

## Contact
[Dan McGraw] - [daniel.e.mcgraw@usace.army.mil]
