# Data Potpourri

A catalog of data science / machine learning methods and applications (*unfinished, currently transfering / organizing from private repositories*)


## Catalog index

### 1. Breast Cancer Wisconsin - `/breastcancer_uci`

Written in R / RMarkdown. A common binary classification machine learning dataset. Estimate whether tumors are malignant or benign. 

Implemented:
- Conditional random forest for prediction
- Calibrated using FP/FN thresholding to optimize specificity (using `caret`)
- Confusion matrix plotting
- Variable importance plotting


### 2. Machine vision for leaf detection - `/leaf_area_machinevision`

Written in Python / Jupyter. Image data collected by my Agroecology students at UC Santa Cruz using a basic point-and-shoot and handheld frame. A variety of methods for machine vision quantification of percent leaf cover from easily-obtained RGB images. 

Implemented:
- 3D plotting of colorspace samples, code for producing rotating 3D projections
- KNN-based segmentation of colorspace into leaf/not-leaf spaces
- 2D embedding of colorspace segmentations (t-SNE, UMAP, TriMap, PCA)
- Edge detection for image segmentation (*code pending*)


### 3. Lygus bug and strawberry damage - `/strawberry_damage_missing`

Written in R and Stan. Strawberry data collected by Diego Nieto as part of the UCSC-OREI project. Implements a Bayesian hierarchical mixture model to estimate both fruit damage (proportion damage in a sample) and flower damage (# missing fruit from observed sample). 

Implemented: 
- Hierarchical mixture model regression for experimental inference
- Workaround for log-probability updates to simulate integer values in the Stan framework (which otherwise uses an MCM sampler that doesn't support integer parameters). 

