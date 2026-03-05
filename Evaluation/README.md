# mlr3torchAUM GSoC 2026 Easy Test Submission

This directory contains the reproductions for the mlr3torchAUM easy test submission.


### Install Dependencies

```r
# Core packages
install.packages(c("remotes", "torch", "mlr3", "mlr3torch", "data.table", "ggplot2", "rmarkdown"))

# Install torch backend
torch::install_torch()

# Install mlr3torchAUM from GitHub
remotes::install_github("tdhock/mlr3torchAUM")
```

## Quick Start

### Rendering

From the Evaluation/ directory in R:

```r
# Render all documents
source("render.R")

# Or render individually
rmarkdown::render("typical-usage/01_typical_usage_reproduction.Rmd")
rmarkdown::render("blog-reproduction/02_blog_reproduction.Rmd")
```

From Terminal:

```bash
cd Evaluation
Rscript -e "source('render.R')"
```

## Execution Environment

All code is executed on CPU only. To prevent CUDA mismatch bugs, CPU execution is automatically forced via the setup chunk of each `.Rmd` file:

```r
Sys.setenv(CUDA_VISIBLE_DEVICES = "-1")
Sys.setenv(TORCH_DEVICE = "cpu")
```

Note: This addresses the CUDA device mismatch issue documented in Issue #13.

## Modifications from Original Vignette

Minimal changes from tdhock's original code:

- Added validation chunks with `stopifnot()` checks after key results
- All original code and parameters (epochs=20, seed=1, lr=0.001) kept identical

## References

- Original vignette: https://github.com/tdhock/mlr3torchAUM/blob/main/vignettes/Typical_usage.Rmd
- CUDA issue: https://github.com/tdhock/mlr3torchAUM/issues/13
