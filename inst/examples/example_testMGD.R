\dontrun{
# ===========================================================================
# Basic usage
# ===========================================================================
model <- "
# Structural model
QUAL ~ EXPE
EXPE ~ IMAG
SAT  ~ IMAG + EXPE + QUAL + VAL
LOY  ~ IMAG + SAT
VAL  ~ EXPE + QUAL

# Measurement model

EXPE <~ expe1 + expe2 + expe3 + expe4 + expe5
IMAG <~ imag1 + imag2 + imag3 + imag4 + imag5
LOY  =~ loy1  + loy2  + loy3  + loy4
QUAL =~ qual1 + qual2 + qual3 + qual4 + qual5
SAT  <~ sat1  + sat2  + sat3  + sat4
VAL  <~ val1  + val2  + val3  + val4
"

## Create list of virtually identical data sets
dat <- list(satisfaction[-3,], satisfaction[-5, ], satisfaction[-10, ])
out <- csem(dat, model, .resample_method = "bootstrap", .R = 40) 

## Test 
testMGD(out, .R_permutation = 40,.verbose = FALSE)

# Notes: 
#  1. .R_permutation (and .R in the call to csem) is small to make examples run quicker; 
#     should be higher in real applications.
#  2. Test will not reject their respective H0s since the groups are virtually
#     identical.
#  3. Only exception is the approach suggested by Sarstedt et al. (2011), a
#     sign that the test is unreliable.
#  4. As opposed to other functions involving the argument, 
#     '.handle_inadmissibles' the default is "replace" as this is
#     required by Sarstedt et al. (2011)'s approach.

# ===========================================================================
# Extended usage
# ===========================================================================
### Test only a subset ------------------------------------------------------
# By default all parameters are compared. Select a subset by providing a 
# model in lavaan model syntax:

to_compare <- "
# Path coefficients
QUAL ~ EXPE

# Loadings
EXPE <~ expe1 + expe2 + expe3 + expe4 + expe5
"

## Test 
testMGD(out, .parameters_to_compare = to_compare, .R_permutation = 20, 
        .R_bootstrap = 20, .verbose = FALSE)

### Different p_adjustments --------------------------------------------------
# To adjust p-values to accommodate multiple testing use .approach_p_adjust. 
# The number of tests to use for adjusting depends on the approach chosen. For
# the Chin approach for example it is the number of parameters to test times the
# number of possible group comparisons. To compare the results for different
# adjustments, a vector of p-adjustments may be chosen.

## Test 
testMGD(out, .parameters_to_compare = to_compare, 
        .approach_p_adjust = c("none", "bonferroni"),
        .R_permutation = 20, .R_bootstrap = 20, .verbose = FALSE)
}
