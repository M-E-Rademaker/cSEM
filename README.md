
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cSEM: Composite-based SEM <img src='man/figures/cSEMsticker.svg' align="right" height="200" /></a>

[![CRAN
status](https://www.r-pkg.org/badges/version/cSEM)](https://cran.r-project.org/package=cSEM)
[![Build
Status](https://travis-ci.com/M-E-Rademaker/cSEM.svg?branch=master)](https://travis-ci.com/M-E-Rademaker/cSEM)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/M-E-Rademaker/cSEM?branch=master&svg=true)](https://ci.appveyor.com/project/M-E-Rademaker/csem)

WARNING: THIS IS WORK IN PROGRESS. BREAKING CHANGES TO THE API ARE VERY
LIKELY. Use the package with caution and please report bugs to [the
package
developers](mailto:manuel.rademaker@uni-wuerzburg.de;f.schuberth@utwente.nl).
The first stable relase will be version 0.0.1, most likely towards the
end of 2019.

## Purpose

Estimate, analyse, test, and study linear, nonlinear, hierachical
structural equation models using composite-based approaches and
procedures, including estimation techniques such as partial least
squares path modeling (PLS-PM) and its derivatives (PLSc, OrdPLSc,
robustPLSc), generalized structured component analysis (GSCA),
generalized structured component analysis with uniqueness terms (GSCAm),
generalized canonical correlation analysis (GCCA), principal component
analysis (PCA), factor score regression (FSR) using sum score,
regression or bartlett scores (including bias correction using Croon’s
approach), as well as several tests and typical postestimation
procedures (e.g., verify admissibility of the estimates, assess the
model fit, test the model fit, compute confidence intervals, compare
groups, etc.).

## Installation

``` r
# Currently only a development version from GitHub is available:
# install.packages("devtools")
devtools::install_github("M-E-Rademaker/cSEM")
```

## Getting started

The best place to get started is the
[cSEM-website](https://m-e-rademaker.github.io/cSEM/) (work in
progress).

## Philosophy

  - First and foremost: `cSEM` has a user-centered design\!
  - “User-centered” mainly boils down to: `cSEM` is easy, i.e. intuitive
    to use by non-R experts\!
    <!--  - There is one central function called `csem()` that provides default choices -->
    <!--    for most of its arguments (similarity to the `sem()` and `cfa()` functions of the [lavaan](http://lavaan.ugent.be/)  -->
    <!--    package is intended). --> <!-- -  -->
    <!--  - cSEM is Well documented (vignettes, HTML output, a website, (eventually) intro course(s) and cheatsheets) -->
    <!--  - Structured output/results  that aims to be "easy"" in a sense that it is -->
    <!--      - ... descriptive/verbose -->
    <!--      - ... (eventually) easy to export to other environments such as MS Word, Latex files etc. (exportability) -->
    <!--      - ... (eventually) easy to migrate from/to/between other PLS/VB/CB-based systems (lavaan, semPLS, ADANCO, SmartPLS) -->
  - The package is designed to be flexible/modular enough so that
    researchers developing new methods can take specific function
    provided by the package and alter them according to their need
    without working their way through a chain of other functions
    (naturally this will not always be possible). Modularity is largly
    inspired by the `matrixpls` package.
  - Modern in a sense that the package integrates modern developments
    within the R community. This mainly includes
    ideas/recommendations/design choices that fead into the packages of
    the [tidyverse](https://github.com/tidyverse/tidyverse).
  - State of the art in a sense that we seek to quickly implement recent
    methodological developments in composite-based SEM.

## Basic usage

The basic usage is illustrated below.

<img src="man/figures/api.png" width="80%" style="display: block; margin: auto;" />

Usully, using `cSEM` is the same 3 step procedure:

> 1.  Pick a dataset and specify a model using [lavaan
>     syntax](http://lavaan.ugent.be/tutorial/syntax1.html)
> 2.  Use `csem()`
> 3.  Apply one of the postestimation functions listed below on the
>     resulting object.

## Postestimation functions

Currently we have five major postestimation verbs:

  - `assess()` : assess the model using common quality criteria
  - `infer()` : calculate common inferencial quantities (e.g, standard
    errors)
  - `predict()` : predict indicator values (not yet implemented)
  - `summarize()` : summarize the results
  - `verify()` : verify admissibility of the estimates

Tests are performed by using the test family of functions. Currently the
following tests are implemented:

  - `testOMF()` : performs a test for overall model fit
  - `testMICOM()` : performs a test for composite measurement invariance
  - `testMGD` : performs several test to assess multi-group differences
  - `testHausman()` : performs the regression-based Hausman test to test
    for endogeneity.

All functions require a `cSEMResults` object.

## Example

Models are defined using [lavaan
syntax](http://lavaan.ugent.be/tutorial/syntax1.html) with some slight
modifications (see the [Specifying a
model](https://m-e-rademaker.github.io/cSEM/articles/cSEM.html#using-csem)
section on the [cSEM-website](https://m-e-rademaker.github.io/cSEM/)).
For illustration we use the build-in and well-known `satisfaction`
dataset.

``` r
require(cSEM)
    
## Note: The operator "<~" tells cSEM that the construct to its left is modelled
##       as a composite.
##       The operator "=~" tells cSEM that the construct to its left is modelled
##       as a common factor.
##       The operator "~" tells cSEM which are the dependent (left-hand side) and
##       independent variables (right-hand side).
    
model <- "
# Structural model
EXPE ~ IMAG
QUAL ~ EXPE
VAL  ~ EXPE + QUAL
SAT  ~ IMAG + EXPE + QUAL + VAL 
LOY  ~ IMAG + SAT

# Composite model
IMAG <~ imag1 + imag2 + imag3
EXPE <~ expe1 + expe2 + expe3 
QUAL <~ qual1 + qual2 + qual3 + qual4 + qual5
VAL  <~ val1  + val2  + val3

# Reflective measurement model
SAT  =~ sat1  + sat2  + sat3  + sat4
LOY  =~ loy1  + loy2  + loy3  + loy4
"
```

The estimation is conducted using the `csem()` function.

``` r
# Estimate using defaults
res <- csem(.data = satisfaction, .model = model)
res
```

    ## ________________________________________________________________________________
    ## ----------------------------------- Overview -----------------------------------
    ## 
    ## Estimation was successful.
    ## 
    ## The result is a list of class cSEMResults with list elements:
    ## 
    ##  - Estimates
    ##  - Information
    ## 
    ## To get an overview or help type:
    ## 
    ##  - ?cSEMResults
    ##  - str(<object-name>)
    ##  - listviewer::jsondedit(<object-name>, mode = 'view')
    ## 
    ## If you wish to access the list elements directly type e.g. 
    ## 
    ##  - <object-name>$Estimates
    ## 
    ## Available postestimation commands:
    ## 
    ##  - assess(<object-name>)
    ##  - infer(<object-name)
    ##  - predict(<object-name>)
    ##  - summarize(<object-name>)
    ##  - verify(<object-name>)
    ## ________________________________________________________________________________

This is equal to:

``` r
csem(
   .data                        = satisfaction,
   .model                       = model,
   .approach_cor_robust         = "none",
   .approach_nl                 = "sequential",
   .approach_paths              = "OLS",
   .approach_weights            = "PLS-PM",
   .conv_criterion              = "diff_absolute",
   .disattenuate                = TRUE,
   .dominant_indicators         = NULL,
   .estimate_structural         = TRUE,
   .id                          = NULL,
   .iter_max                    = 100,
   .normality                   = FALSE,
   .PLS_approach_cf             = "dist_squared_euclid",
   .PLS_ignore_structural_model = FALSE,
   .PLS_modes                   = NULL,
   .PLS_weight_scheme_inner     = "path",
   .reliabilities               = NULL,
   .starting_values             = NULL,
   .tolerance                   = 1e-05,
   .resample_method             = "none", 
   .resample_method2            = "none",
   .R                           = 499,
   .R2                          = 199,
   .handle_inadmissibles        = "drop",
   .user_funs                   = NULL,
   .eval_plan                   = "sequential",
   .seed                        = NULL,
   .sign_change_option          = "none"
    )
```

The result is always a named list of class `cSEMResults`.

To access list elements use `$`:

``` r
res$Estimates$Loading_estimates 
res$Information$Model
```

A usefule tool to examine a list is the [listviewer
package](https://github.com/timelyportfolio/listviewer). If you are new
to `cSEM` this might be a good way to familiarize yourself with the
structure of a `cSEMResults` object.

``` r
listviewer::jsonedit(res, mode = "view") # requires the listviewer package.
```

Apply postestimation functions:

``` r
## Get a summary
summarize(res) 
```

    ## ________________________________________________________________________________
    ## ----------------------------------- Overview -----------------------------------
    ## 
    ##  General information:
    ##  ------------------------
    ##  Number of observations           = 250
    ##  Weight estimator                 = PLS-PM
    ##  Inner weighting scheme           = path
    ##  Type of indicator correlation    = Bravais-Pearson
    ##  Path model estimator             = OLS
    ##  Second order approach            = NA
    ##  Type of path model               = Linear
    ##  Disattenuated                    = Yes (PLSc)
    ## 
    ##  Construct details:
    ##  ------------------
    ##  Name  Modeled as     Order         Mode 
    ## 
    ##  IMAG  Composite      First order   modeB
    ##  EXPE  Composite      First order   modeB
    ##  QUAL  Composite      First order   modeB
    ##  VAL   Composite      First order   modeB
    ##  SAT   Common factor  First order   modeA
    ##  LOY   Common factor  First order   modeA
    ## 
    ## ----------------------------------- Estimates ----------------------------------
    ## 
    ## Estimated path coefficients:
    ## ============================
    ##   Path           Estimate  Std. error   t-stat.   p-value
    ##   EXPE ~ IMAG      0.4714          NA        NA        NA
    ##   QUAL ~ EXPE      0.8344          NA        NA        NA
    ##   VAL ~ EXPE       0.0457          NA        NA        NA
    ##   VAL ~ QUAL       0.7013          NA        NA        NA
    ##   SAT ~ IMAG       0.2450          NA        NA        NA
    ##   SAT ~ EXPE      -0.0172          NA        NA        NA
    ##   SAT ~ QUAL       0.2215          NA        NA        NA
    ##   SAT ~ VAL        0.5270          NA        NA        NA
    ##   LOY ~ IMAG       0.1819          NA        NA        NA
    ##   LOY ~ SAT        0.6283          NA        NA        NA
    ## 
    ## Estimated Loadings:
    ## ===================
    ##   Loading          Estimate  Std. error   t-stat.   p-value
    ##   IMAG =~ imag1      0.6306          NA        NA        NA
    ##   IMAG =~ imag2      0.9246          NA        NA        NA
    ##   IMAG =~ imag3      0.9577          NA        NA        NA
    ##   EXPE =~ expe1      0.7525          NA        NA        NA
    ##   EXPE =~ expe2      0.9348          NA        NA        NA
    ##   EXPE =~ expe3      0.7295          NA        NA        NA
    ##   QUAL =~ qual1      0.7861          NA        NA        NA
    ##   QUAL =~ qual2      0.9244          NA        NA        NA
    ##   QUAL =~ qual3      0.7560          NA        NA        NA
    ##   QUAL =~ qual4      0.7632          NA        NA        NA
    ##   QUAL =~ qual5      0.7834          NA        NA        NA
    ##   VAL =~ val1        0.9518          NA        NA        NA
    ##   VAL =~ val2        0.8056          NA        NA        NA
    ##   VAL =~ val3        0.6763          NA        NA        NA
    ##   SAT =~ sat1        0.9243          NA        NA        NA
    ##   SAT =~ sat2        0.8813          NA        NA        NA
    ##   SAT =~ sat3        0.7127          NA        NA        NA
    ##   SAT =~ sat4        0.7756          NA        NA        NA
    ##   LOY =~ loy1        0.9097          NA        NA        NA
    ##   LOY =~ loy2        0.5775          NA        NA        NA
    ##   LOY =~ loy3        0.9043          NA        NA        NA
    ##   LOY =~ loy4        0.4917          NA        NA        NA
    ## 
    ## Estimated Weights:
    ## ==================
    ##   Weights          Estimate  Std. error   t-stat.   p-value
    ##   IMAG <~ imag1      0.0156          NA        NA        NA
    ##   IMAG <~ imag2      0.4473          NA        NA        NA
    ##   IMAG <~ imag3      0.6020          NA        NA        NA
    ##   EXPE <~ expe1      0.2946          NA        NA        NA
    ##   EXPE <~ expe2      0.6473          NA        NA        NA
    ##   EXPE <~ expe3      0.2374          NA        NA        NA
    ##   QUAL <~ qual1      0.2370          NA        NA        NA
    ##   QUAL <~ qual2      0.4712          NA        NA        NA
    ##   QUAL <~ qual3      0.1831          NA        NA        NA
    ##   QUAL <~ qual4      0.1037          NA        NA        NA
    ##   QUAL <~ qual5      0.2049          NA        NA        NA
    ##   VAL <~ val1        0.7163          NA        NA        NA
    ##   VAL <~ val2        0.2202          NA        NA        NA
    ##   VAL <~ val3        0.2082          NA        NA        NA
    ##   SAT <~ sat1        0.3209          NA        NA        NA
    ##   SAT <~ sat2        0.3059          NA        NA        NA
    ##   SAT <~ sat3        0.2474          NA        NA        NA
    ##   SAT <~ sat4        0.2692          NA        NA        NA
    ##   LOY <~ loy1        0.3834          NA        NA        NA
    ##   LOY <~ loy2        0.2434          NA        NA        NA
    ##   LOY <~ loy3        0.3812          NA        NA        NA
    ##   LOY <~ loy4        0.2073          NA        NA        NA
    ## 
    ## ------------------------------------ Effects -----------------------------------
    ## 
    ## Estimated total effects:
    ## ========================
    ##   Total effect    Estimate  Std. error   t-stat.   p-value
    ##   EXPE ~ IMAG       0.4714          NA        NA        NA
    ##   QUAL ~ IMAG       0.3933          NA        NA        NA
    ##   QUAL ~ EXPE       0.8344          NA        NA        NA
    ##   VAL ~ IMAG        0.2974          NA        NA        NA
    ##   VAL ~ EXPE        0.6309          NA        NA        NA
    ##   VAL ~ QUAL        0.7013          NA        NA        NA
    ##   SAT ~ IMAG        0.4807          NA        NA        NA
    ##   SAT ~ EXPE        0.5001          NA        NA        NA
    ##   SAT ~ QUAL        0.5911          NA        NA        NA
    ##   SAT ~ VAL         0.5270          NA        NA        NA
    ##   LOY ~ IMAG        0.4840          NA        NA        NA
    ##   LOY ~ EXPE        0.3142          NA        NA        NA
    ##   LOY ~ QUAL        0.3714          NA        NA        NA
    ##   LOY ~ VAL         0.3311          NA        NA        NA
    ##   LOY ~ SAT         0.6283          NA        NA        NA
    ## 
    ## Estimated indirect effects:
    ## ===========================
    ##   Indirect effect    Estimate  Std. error   t-stat.   p-value
    ##   QUAL ~ IMAG          0.3933          NA        NA        NA
    ##   VAL ~ IMAG           0.2974          NA        NA        NA
    ##   VAL ~ EXPE           0.5852          NA        NA        NA
    ##   SAT ~ IMAG           0.2357          NA        NA        NA
    ##   SAT ~ EXPE           0.5173          NA        NA        NA
    ##   SAT ~ QUAL           0.3696          NA        NA        NA
    ##   LOY ~ IMAG           0.3020          NA        NA        NA
    ##   LOY ~ EXPE           0.3142          NA        NA        NA
    ##   LOY ~ QUAL           0.3714          NA        NA        NA
    ##   LOY ~ VAL            0.3311          NA        NA        NA
    ## ________________________________________________________________________________

``` r
## Verify admissibility of the results
verify(res) 
```

    ## ________________________________________________________________________________
    ## 
    ## Verify admissibility:
    ## 
    ##   admissible
    ## 
    ## Details:
    ## 
    ##   Code   Status    Description
    ##   1      ok        Convergence achieved                                   
    ##   2      ok        All absolute standardized loading estimates <= 1       
    ##   3      ok        Construct VCV is positive semi-definite                
    ##   4      ok        All reliability estimates <= 1                         
    ##   5      ok        Model-implied indicator VCV is positive semi-definite  
    ## ________________________________________________________________________________

``` r
# ## Test overall model fit
testOMF(res, .verbose = FALSE)
```

    ## ________________________________________________________________________________
    ## --------- Test for overall model fit based on Beran & Srivastava (1985) --------
    ## 
    ## Null hypothesis:
    ## 
    ##                                               +------------------------------------------------------------+
    ##                                               |                                                            |
    ##                                               |   H0: Population indicator covariance matrix is equal to   |
    ##                                               |   model-implied indicator covariance matrix.               |
    ##                                               |                                                            |
    ##                                               +------------------------------------------------------------+
    ## 
    ## Test statistic and critical value: 
    ## 
    ##                                      Critical value
    ##  Distance measure    Test statistic    95%   
    ##  dG                      0.6493      0.3319  
    ##  SRMR                    0.0940      0.0527  
    ##  dL                      2.2340      0.7015  
    ##  
    ## 
    ## Decision: 
    ## 
    ##                          Significance level
    ##  Distance measure          95%   
    ##  dG                      reject  
    ##  SRMR                    reject  
    ##  dL                      reject  
    ##  
    ## Additonal information:
    ## 
    ##  Out of 499 bootstrap replications 471 are admissible.
    ##  See ?verify() for what constitutes an inadmissible result.
    ## 
    ##  The seed used was: -712706911
    ## ________________________________________________________________________________

``` r
## Assess the model
assess(res)
```

    ## ________________________________________________________________________________
    ## 
    ##  Construct        AVE          RhoC      RhoC_weighted      R2          R2_adj         RhoT      RhoT_weighted
    ##  SAT            0.6851        0.8938        0.9051        0.7624        0.7585        0.8940        0.8869    
    ##  LOY            0.5552        0.8011        0.8761        0.5868        0.5834        0.8194        0.7850    
    ## 
    ## --------------------------- Distance and fit measures --------------------------
    ## 
    ##  Geodesic distance           = 0.6493432
    ##  Squared Euclidian distance  = 2.23402
    ##  ML distance                 = 2.921932
    ## 
    ##  CFI          = 0.8573048
    ##  GFI          = 0.9642375
    ##  IFI          = 0.8593711
    ##  NFI          = 0.8229918
    ##  NNFI         = 0.8105598
    ##  RMSEA        = 0.1130338
    ##  RMS_theta    = 0.05069299
    ##  SRMR         = 0.09396871
    ## 
    ##  Degrees of freedom    = 174
    ## 
    ## ----------------------- Variance inflation factors (VIFs) ----------------------
    ## 
    ##   Dependent construct: 'VAL'
    ## 
    ##  Independent construct    VIF value 
    ##  EXPE                      3.2928   
    ##  QUAL                      3.2928   
    ##  IMAG                      0.0000   
    ##  VAL                       0.0000   
    ##  SAT                       0.0000   
    ## 
    ##   Dependent construct: 'SAT'
    ## 
    ##  Independent construct    VIF value 
    ##  EXPE                      3.2985   
    ##  QUAL                      4.4151   
    ##  IMAG                      1.7280   
    ##  VAL                       2.6726   
    ##  SAT                       0.0000   
    ## 
    ##   Dependent construct: 'LOY'
    ## 
    ##  Independent construct    VIF value 
    ##  EXPE                      0.0000   
    ##  QUAL                      0.0000   
    ##  IMAG                      1.9345   
    ##  VAL                       0.0000   
    ##  SAT                       1.9345   
    ## 
    ## --------------------------- Effect sizes (f_squared) ---------------------------
    ## 
    ##   Dependent construct: 'EXPE'
    ## 
    ##  Independent construct   Effect size
    ##  IMAG                      0.2856   
    ## 
    ##   Dependent construct: 'QUAL'
    ## 
    ##  Independent construct   Effect size
    ##  EXPE                      2.2928   
    ## 
    ##   Dependent construct: 'VAL'
    ## 
    ##  Independent construct   Effect size
    ##  EXPE                      0.0014   
    ##  QUAL                      0.3301   
    ## 
    ##   Dependent construct: 'SAT'
    ## 
    ##  Independent construct   Effect size
    ##  IMAG                      0.1462   
    ##  EXPE                      0.0004   
    ##  QUAL                      0.0468   
    ##  VAL                       0.4373   
    ## 
    ##   Dependent construct: 'LOY'
    ## 
    ##  Independent construct   Effect size
    ##  IMAG                      0.0414   
    ##  SAT                       0.4938   
    ## 
    ## ------------------------------ Validity assessment -----------------------------
    ## 
    ##  Heterotrait-montrait ratio of correlation matrix (HTMT matrix)
    ## 
    ##           SAT LOY
    ## SAT 0.0000000   0
    ## LOY 0.7432489   0
    ## 
    ## 
    ##  Fornell-Larcker matrix
    ## 
    ##           SAT       LOY
    ## SAT 0.6851491 0.5696460
    ## LOY 0.5696460 0.5551718
    ## 
    ## 
    ##  Redundancy analysis
    ## 
    ##  Construct       Value    
    ##  IMAG           0.9750    
    ##  EXPE           0.9873    
    ##  QUAL           0.9909    
    ##  VAL            0.9744    
    ## ________________________________________________________________________________

#### Resampling and Inference

By default no inferential quantities are calculated since most
composite-based estimators have no closed-form expressions for standard
errors. Some closed form standard error are implemented, however, this
feature is still rather preliminary. It is therefore recommoned to use
resampling instead. `cSEM` mostly relies on the `bootstrap` procedure
(although `jackknife` is implemented as well) to estimate standard
errors, test statistics, and critical quantiles.

`cSEM` offers two ways to compute resamples:

1.  Setting `.resample_method` to `"jackkinfe"` or `"bootstrap"` and
    subsequently using postestimation functions `summarize()` or
    `infer()`.
2.  The same result is achieved by passing a `cSEMResults` object to
    `resamplecSEMResults()` and subsequently using postestimation
    functions `summarize()` or `infer()`.

<!-- end list -->

``` r
# Setting `.resample_method`
b1 <- csem(.data = satisfaction, .model = model, .resample_method = "bootstrap")
b2 <- resamplecSEMResults(res)
```

Now `summarize()` shows inferencial quantities as well:

``` r
summarize(b1)
```

    ## ________________________________________________________________________________
    ## ----------------------------------- Overview -----------------------------------
    ## 
    ##  General information:
    ##  ------------------------
    ##  Number of observations           = 250
    ##  Weight estimator                 = PLS-PM
    ##  Inner weighting scheme           = path
    ##  Type of indicator correlation    = Bravais-Pearson
    ##  Path model estimator             = OLS
    ##  Second order approach            = NA
    ##  Type of path model               = Linear
    ##  Disattenuated                    = Yes (PLSc)
    ## 
    ##  Resample information:
    ##  ---------------------
    ##  Resample methode                 = bootstrap
    ##  Number of resamples              = 499
    ##  Number of admissible results     = 492
    ##  Approach to handle inadmissibles = drop
    ##  Sign change option               = none
    ##  Random seed                      = -450643294
    ## 
    ##  Construct details:
    ##  ------------------
    ##  Name  Modeled as     Order         Mode 
    ## 
    ##  IMAG  Composite      First order   modeB
    ##  EXPE  Composite      First order   modeB
    ##  QUAL  Composite      First order   modeB
    ##  VAL   Composite      First order   modeB
    ##  SAT   Common factor  First order   modeA
    ##  LOY   Common factor  First order   modeA
    ## 
    ## ----------------------------------- Estimates ----------------------------------
    ## 
    ## Estimated path coefficients:
    ## ============================
    ##                                                              CI_percentile   
    ##   Path           Estimate  Std. error   t-stat.   p-value         95%        
    ##   EXPE ~ IMAG      0.4714      0.0633    7.4422    0.0000  [ 0.3515; 0.5884] 
    ##   QUAL ~ EXPE      0.8344      0.0239   34.8783    0.0000  [ 0.7865; 0.8754] 
    ##   VAL ~ EXPE       0.0457      0.0853    0.5362    0.5918  [-0.1093; 0.2145] 
    ##   VAL ~ QUAL       0.7013      0.0817    8.5871    0.0000  [ 0.5410; 0.8575] 
    ##   SAT ~ IMAG       0.2450      0.0540    4.5403    0.0000  [ 0.1441; 0.3507] 
    ##   SAT ~ EXPE      -0.0172      0.0697   -0.2473    0.8047  [-0.1605; 0.1165] 
    ##   SAT ~ QUAL       0.2215      0.1002    2.2105    0.0271  [ 0.0412; 0.4371] 
    ##   SAT ~ VAL        0.5270      0.0824    6.3989    0.0000  [ 0.3683; 0.6824] 
    ##   LOY ~ IMAG       0.1819      0.0816    2.2308    0.0257  [ 0.0189; 0.3347] 
    ##   LOY ~ SAT        0.6283      0.0824    7.6246    0.0000  [ 0.4771; 0.7881] 
    ## 
    ## Estimated Loadings:
    ## ===================
    ##                                                                CI_percentile   
    ##   Loading          Estimate  Std. error   t-stat.   p-value         95%        
    ##   IMAG =~ imag1      0.6306      0.0982    6.4236    0.0000  [ 0.4275; 0.8163] 
    ##   IMAG =~ imag2      0.9246      0.0431   21.4688    0.0000  [ 0.8084; 0.9790] 
    ##   IMAG =~ imag3      0.9577      0.0306   31.2798    0.0000  [ 0.8760; 0.9923] 
    ##   EXPE =~ expe1      0.7525      0.0791    9.5192    0.0000  [ 0.5777; 0.8677] 
    ##   EXPE =~ expe2      0.9348      0.0285   32.8136    0.0000  [ 0.8644; 0.9726] 
    ##   EXPE =~ expe3      0.7295      0.0700   10.4220    0.0000  [ 0.5659; 0.8449] 
    ##   QUAL =~ qual1      0.7861      0.0681   11.5458    0.0000  [ 0.6203; 0.8917] 
    ##   QUAL =~ qual2      0.9244      0.0233   39.6260    0.0000  [ 0.8658; 0.9563] 
    ##   QUAL =~ qual3      0.7560      0.0577   13.1070    0.0000  [ 0.6326; 0.8560] 
    ##   QUAL =~ qual4      0.7632      0.0530   14.4063    0.0000  [ 0.6463; 0.8596] 
    ##   QUAL =~ qual5      0.7834      0.0452   17.3231    0.0000  [ 0.6943; 0.8656] 
    ##   VAL =~ val1        0.9518      0.0220   43.3216    0.0000  [ 0.8983; 0.9858] 
    ##   VAL =~ val2        0.8056      0.0637   12.6394    0.0000  [ 0.6740; 0.9091] 
    ##   VAL =~ val3        0.6763      0.0687    9.8371    0.0000  [ 0.5260; 0.7914] 
    ##   SAT =~ sat1        0.9243      0.0228   40.4906    0.0000  [ 0.8749; 0.9652] 
    ##   SAT =~ sat2        0.8813      0.0293   30.1250    0.0000  [ 0.8179; 0.9301] 
    ##   SAT =~ sat3        0.7127      0.0524   13.6041    0.0000  [ 0.5997; 0.8015] 
    ##   SAT =~ sat4        0.7756      0.0521   14.8782    0.0000  [ 0.6695; 0.8585] 
    ##   LOY =~ loy1        0.9097      0.0493   18.4383    0.0000  [ 0.7956; 0.9810] 
    ##   LOY =~ loy2        0.5775      0.0891    6.4811    0.0000  [ 0.3765; 0.7215] 
    ##   LOY =~ loy3        0.9043      0.0441   20.5246    0.0000  [ 0.8082; 0.9757] 
    ##   LOY =~ loy4        0.4917      0.0939    5.2365    0.0000  [ 0.2984; 0.6519] 
    ## 
    ## Estimated Weights:
    ## ==================
    ##                                                                CI_percentile   
    ##   Weights          Estimate  Std. error   t-stat.   p-value         95%        
    ##   IMAG <~ imag1      0.0156      0.1138    0.1375    0.8907  [-0.2107; 0.2433] 
    ##   IMAG <~ imag2      0.4473      0.1543    2.8983    0.0038  [ 0.1246; 0.7480] 
    ##   IMAG <~ imag3      0.6020      0.1452    4.1471    0.0000  [ 0.3043; 0.8732] 
    ##   EXPE <~ expe1      0.2946      0.1144    2.5748    0.0100  [ 0.0452; 0.5123] 
    ##   EXPE <~ expe2      0.6473      0.0874    7.4099    0.0000  [ 0.4578; 0.7974] 
    ##   EXPE <~ expe3      0.2374      0.0907    2.6166    0.0089  [ 0.0592; 0.4036] 
    ##   QUAL <~ qual1      0.2370      0.0892    2.6587    0.0078  [ 0.0747; 0.4200] 
    ##   QUAL <~ qual2      0.4712      0.0767    6.1421    0.0000  [ 0.3207; 0.6119] 
    ##   QUAL <~ qual3      0.1831      0.0757    2.4173    0.0156  [ 0.0274; 0.3199] 
    ##   QUAL <~ qual4      0.1037      0.0584    1.7762    0.0757  [-0.0052; 0.2199] 
    ##   QUAL <~ qual5      0.2049      0.0630    3.2524    0.0011  [ 0.0694; 0.3302] 
    ##   VAL <~ val1        0.7163      0.0921    7.7769    0.0000  [ 0.5304; 0.8817] 
    ##   VAL <~ val2        0.2202      0.0914    2.4093    0.0160  [ 0.0446; 0.3984] 
    ##   VAL <~ val3        0.2082      0.0576    3.6165    0.0003  [ 0.0997; 0.3223] 
    ##   SAT <~ sat1        0.3209      0.0155   20.6506    0.0000  [ 0.2957; 0.3559] 
    ##   SAT <~ sat2        0.3059      0.0139   22.0689    0.0000  [ 0.2834; 0.3354] 
    ##   SAT <~ sat3        0.2474      0.0107   23.0191    0.0000  [ 0.2245; 0.2676] 
    ##   SAT <~ sat4        0.2692      0.0128   21.0850    0.0000  [ 0.2445; 0.2935] 
    ##   LOY <~ loy1        0.3834      0.0268   14.3259    0.0000  [ 0.3279; 0.4364] 
    ##   LOY <~ loy2        0.2434      0.0311    7.8364    0.0000  [ 0.1698; 0.2923] 
    ##   LOY <~ loy3        0.3812      0.0272   14.0268    0.0000  [ 0.3330; 0.4377] 
    ##   LOY <~ loy4        0.2073      0.0353    5.8657    0.0000  [ 0.1325; 0.2692] 
    ## 
    ## ------------------------------------ Effects -----------------------------------
    ## 
    ## Estimated total effects:
    ## ========================
    ##                                                               CI_percentile   
    ##   Total effect    Estimate  Std. error   t-stat.   p-value         95%        
    ##   EXPE ~ IMAG       0.4714      0.0633    7.4422    0.0000  [ 0.3515; 0.5884] 
    ##   QUAL ~ IMAG       0.3933      0.0593    6.6344    0.0000  [ 0.2814; 0.5012] 
    ##   QUAL ~ EXPE       0.8344      0.0239   34.8783    0.0000  [ 0.7865; 0.8754] 
    ##   VAL ~ IMAG        0.2974      0.0600    4.9525    0.0000  [ 0.1941; 0.4207] 
    ##   VAL ~ EXPE        0.6309      0.0516   12.2287    0.0000  [ 0.5305; 0.7310] 
    ##   VAL ~ QUAL        0.7013      0.0817    8.5871    0.0000  [ 0.5410; 0.8575] 
    ##   SAT ~ IMAG        0.4807      0.0645    7.4481    0.0000  [ 0.3612; 0.6118] 
    ##   SAT ~ EXPE        0.5001      0.0577    8.6675    0.0000  [ 0.3916; 0.6103] 
    ##   SAT ~ QUAL        0.5911      0.0940    6.2890    0.0000  [ 0.4159; 0.7880] 
    ##   SAT ~ VAL         0.5270      0.0824    6.3989    0.0000  [ 0.3683; 0.6824] 
    ##   LOY ~ IMAG        0.4840      0.0671    7.2095    0.0000  [ 0.3576; 0.6130] 
    ##   LOY ~ EXPE        0.3142      0.0536    5.8581    0.0000  [ 0.2211; 0.4311] 
    ##   LOY ~ QUAL        0.3714      0.0822    4.5168    0.0000  [ 0.2198; 0.5546] 
    ##   LOY ~ VAL         0.3311      0.0728    4.5461    0.0000  [ 0.2049; 0.4808] 
    ##   LOY ~ SAT         0.6283      0.0824    7.6246    0.0000  [ 0.4771; 0.7881] 
    ## 
    ## Estimated indirect effects:
    ## ===========================
    ##                                                                  CI_percentile   
    ##   Indirect effect    Estimate  Std. error   t-stat.   p-value         95%        
    ##   QUAL ~ IMAG          0.3933      0.0593    6.6344    0.0000  [ 0.2814; 0.5012] 
    ##   VAL ~ IMAG           0.2974      0.0600    4.9525    0.0000  [ 0.1941; 0.4207] 
    ##   VAL ~ EXPE           0.5852      0.0707    8.2768    0.0000  [ 0.4484; 0.7241] 
    ##   SAT ~ IMAG           0.2357      0.0472    4.9922    0.0000  [ 0.1506; 0.3395] 
    ##   SAT ~ EXPE           0.5173      0.0690    7.4972    0.0000  [ 0.3891; 0.6531] 
    ##   SAT ~ QUAL           0.3696      0.0618    5.9842    0.0000  [ 0.2570; 0.4983] 
    ##   LOY ~ IMAG           0.3020      0.0554    5.4562    0.0000  [ 0.2105; 0.4239] 
    ##   LOY ~ EXPE           0.3142      0.0536    5.8581    0.0000  [ 0.2211; 0.4311] 
    ##   LOY ~ QUAL           0.3714      0.0822    4.5168    0.0000  [ 0.2198; 0.5546] 
    ##   LOY ~ VAL            0.3311      0.0728    4.5461    0.0000  [ 0.2049; 0.4808] 
    ## ________________________________________________________________________________

Several resample-based confidence intervals are implemented, see
`?infer()`:

``` r
infer(b1, .quantity = c("CI_standard_z", "CI_percentile")) # no print method yet
```

Both bootstrap and jackknife resampling support platform-independent
multiprocessing as well as setting random seeds via the [future
framework](https://github.com/HenrikBengtsson/future). For
multiprocessing simply set `.eval_plan = "multiprocess"` in which case
the maximum number of available cores is used if not on Windows. On
Windows as many separate R instances are opened in the backround as
there are cores available instead. Note that this naturally has some
overhead so for a small number of resamples multiprocessing will not
always be faster compared to sequential (single core) processing (the
default). Seeds are set via the `.seed` argument.

``` r
b <- csem(
  .data            = satisfaction,
  .model           = model, 
  .resample_method = "bootstrap",
  .R               = 999,
  .seed            = 98234,
  .eval_plan       = "multiprocess")
```
