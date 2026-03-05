# Development Notes and Debugging Log

I am documenting issues faced while making solution for test.

### Issue 1: CUDA Device Mismatch

**Problem:** On systems with CUDA GPUs, torch may attempt to use CUDA for some operations and CPU for others, causing device mismatch errors, I have investigated this issue and raised a issue (issue #13).

**Reference:** https://github.com/tdhock/mlr3torchAUM/issues/13

For now I have forced CPU-only execution by setting environment variables before loading torch:

```r
Sys.setenv(CUDA_VISIBLE_DEVICES = "-1")
Sys.setenv(TORCH_DEVICE = "cpu")
```

Verification:

Run `torch::torch_tensor(1)$device` in R console after setting env vars

Should return: `torch_device(type='cpu')`

### Issue 2: CRAN mirror not set during render

**Problem:** Rendering failed with "trying to use CRAN without setting a mirror" when install.packages was called non-interactively.

**Solution:** Added `options(repos = c(CRAN = "https://cloud.r-project.org"))` before install.packages in 01_typical_usage_reproduction.Rmd.
