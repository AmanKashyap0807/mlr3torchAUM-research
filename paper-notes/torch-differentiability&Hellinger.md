To implement the IMCP normalized Macro AUM in `mlr3torchAUM`, the entire One-vs-Rest (OvR) process and sample weighting must be differentiable so gradients can flow back to `pred_tensor`.

## Tensor Operation Strategy
1. **Avoiding loops:** Instead of a `for` loop that might break the gradient tape or slow down execution, we use parallel tensor operations.
2. **Broadcasting Weights:** To apply the class weights ($\delta_i = 1 / (K \cdot count)$), we use `unsqueeze(1)`. This transforms a 1D weight vector `(K)` into a 2D row vector `(1, K)`, allowing element-wise multiplication with the `(N, K)` one-hot label matrix via broadcasting.
3. **Sorting:** To calculate AUM, we must sort predictions. `torch::torch_gather(dim=1, index=sorted_indices)` is used instead of base R indexing to ensure the computational graph tracks the reordering for the backward pass.

## The Hellinger Penalty
The paper suggests addressing prediction uncertainty. 
- Formula: $H = \sqrt{1 - \sqrt{p_k}}$ (where $p_k$ is the predicted probability for the true class).
- Effect on gradients: The derivative of $H$ is steep when $p_k$ is small. Adding this as an optional penalty to the AUM loss provides a stronger gradient signal for highly uncertain predictions, preventing the model from ignoring minority classes in highly imbalanced datasets.