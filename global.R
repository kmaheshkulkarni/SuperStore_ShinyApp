source("pkg.R")

# navbarTab <- function(tabName, ..., icon = NULL) {
#   tags$li(
#     class = "nav-item",
#     tags$a(
#       class = "nav-link",
#       id = paste0("tab-", tabName),
#       href = paste0("#shiny-tab-", tabName),
#       `data-toggle` = "tab",
#       `data-value` = tabName,
#       icon,
#       tags$p(...)
#     )
#   )
# }
# 
# 
# navbarMenu <- function(..., id = NULL) {
#   if (is.null(id)) id <- paste0("tabs_", round(stats::runif(1, min = 0, max = 1e9)))
#   
#   tags$ul(
#     class = "nav dropdown", 
#     role = "menu",
#     id = "sidebar-menu",
#     ...,
#     div(
#       id = id,
#       class = "sidebarMenuSelectedTabItem",
#       `data-value` = "null",
#       
#     )
#   )
# }
