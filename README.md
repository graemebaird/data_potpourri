# data_potpourri
A catalog of data science / machine learning methods and applications


## Catalog index

1. Breast Cancer Wisconsin - `/breastcancer_uci`

A common binary classification machine learning dataset. Estimate whether tumors are malignant or benign. 

Implements:
- Conditional random forest for prediction
- Calibrated using FP/FN thresholding to optimize specificity (using `caret`)
- Confusion matrix plotting
- Variable importance plotting
