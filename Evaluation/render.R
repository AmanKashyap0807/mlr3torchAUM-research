# Master render script for mlr3torchAUM Easy Test submission

# Typical Usage Vignette
cat("Typical Usage Vignette Reproduction\n")
cat("-----------------------------------------------------------\n")

tryCatch({
  rmarkdown::render(
    input = "typical-usage/01_typical_usage_reproduction.Rmd",
    output_dir = "typical-usage",
    quiet = FALSE
  )
  cat("typical usage rendered successfully\n\n")
}, error = function(e) {
  cat("typical usage rendering failed:\n")
  cat("Error:", conditionMessage(e), "\n")
})

# Blog Post Code Reproduction
cat("Blog Post Code Reproduction\n")
cat("-----------------------------------------------------------\n")

tryCatch({
  rmarkdown::render(
    input = "blog-reproduction/02_blog_reproduction.Rmd",
    output_dir = "blog-reproduction",
    quiet = FALSE
  )
  cat("Blog Post Code Reproduction rendered successfully\n\n")
}, error = function(e) {
  cat("Blog Post Code Reproduction rendering failed:\n")
  cat("Error:", conditionMessage(e), "\n")
})

cat("═══════════════════════════════════════════════════════════\n")
cat("Rendering complete!\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat("View results:\n")
cat("- typical-usage/01_typical_usage_reproduction.html\n")
cat("- blog-reproduction/02_blog_reproduction.html\n\n")