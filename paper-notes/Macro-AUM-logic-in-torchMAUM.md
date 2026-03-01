**Pweights/Nweights**
```
  if ((pred_tensor$ndim)==1  ) {
    pred_tensor2 <- torch::torch_stack(
      list(1 - pred_tensor, pred_tensor),
      dim = 2
    )
    n_class <- 2

  } else {
    if(pred_tensor$size(2)==1){
      pred_tensor2 <-torch::torch_cat(list(1 - pred_tensor, pred_tensor),
                                      dim = 2)
      n_class <- 2
    }
    else{
      n_class <- pred_tensor$size(2)
      pred_tensor2 <-pred_tensor
    }

  }
  if(!is.null(counts)){
    stopifnot(length(counts) == n_class)
    Pweights <- 1 / (counts + 1e-8)
    Pweights <- Pweights / Pweights$sum()
    Nweights <-1/(counts$sum()-counts+1e-8)
    Nweights <-Nweights/ Nweights$sum()
  }
  else{
    Pweights<-1
    Nweights<-1
  }
  ```

Nature paper uses IMCP normalization to ensure class contribution 1/k to total loss but torchMAUM does not use it, it uses simple one hot encoding without weighting, in torchmlr3 i will implement this also

  **MACRO AUM**
```
  one_hot_labels = torch::nnf_one_hot(label_tensor, num_classes=n_class)
  is_positive = one_hot_labels
  is_negative =1-one_hot_labels
  fn_diff = -is_positive
  fp_diff = is_negative

  thresh_tensor = -pred_tensor2
  fn_denom = is_positive$sum(dim = 1)$clamp(min=1)
  fp_denom = is_negative$sum(dim = 1)$clamp(min=1)
  sorted_indices = torch::torch_argsort(thresh_tensor, dim = 1)
  sorted_fp_cum = torch::torch_gather(fp_diff, dim=1, index=sorted_indices)$cumsum(1)/fp_denom
  sorted_fn_cum = -torch::torch_gather(fn_diff, dim=1, index=sorted_indices)$flip(1)$cumsum(1)$flip(1)/fn_denom
  ```

Hellinger distance


torch::torch_gather(input, dim, index)
Reorders/selects elements from input using index tensor whose shape matches the selection shape.
Differentiable with respect to the input values (gradients flow back into input); indices must be integer tensors (non-differentiable w.r.t. indices).
Exactly what OGuenoun uses to reorder each row independently (argsort gives indices per-row, then gather with dim=1).
Advanced indexing (e.g., input[sorted_indices] in the tdhock binary code)
In R torch this works to reorder values after argsort and is also differentiable w.r.t. the values (again, not w.r.t. indices).
It is effectively doing the same job as gather for the binary code; gather is the explicit, robust way when you have shaped index tensors (NxM).
torch.take
PyTorch's take flattens the input and extracts by flattened indices (1D output); it's not suitable for per-row reorderings where you need to preserve row/column shapes.
I did not find torch.take used in these repos; prefer torch_gather for per-row reorder in multi-class AUM.