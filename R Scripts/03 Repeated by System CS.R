#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 3: Repeated by System - Compound Symmetry Assumption                    #
#==============================================================================#

sys <- 'Drip'

# Fitting a split plot in time/space model. Note the warning which says 
# "singular fit", which indicates that one or more random effect was estimated
# to be essentially zero.
model_spt <- lmer(
  response ~ trt * year * DAP * D_class + 
    (1 | block) + 
    (1 | block:trt) +
    (1 | block:year) +
    (1 | block:trt:year) +
    (1 | block:DAP) +
    (1 | block:trt:year:DAP),
  data = filter(soilN, system == sys),
  REML = TRUE
)

# We can check model fit/verify model assumptions through residual diagnostic
# plots (don't worry about the warning messages). We can see clear problems with
# heteroscedasticity.
resid_panel(model_spt, type = 'pearson')

(vc_spt <- VarCorr(model_spt)) # Variance parameter estimates

(ftest_spt <- joint_tests(model_spt, mode = 'satterthwaite')) # Type III tests of fixed effects

# Fitting a repeated measures model assuming compound symmetry for depth. Again,
# we see issues of singular fit.
model_cs <- lmer(
  response ~ trt * year * DAP * D_class + 
    (1 | block) + 
    (1 | block:trt) +
    (1 | block:trt:year) +
    (1 | block:trt:year:DAP),
  data = filter(soilN, system == sys),
  REML = TRUE
)

# Issues with heteroscedasticity remain
resid_panel(model_cs, type = 'pearson')

# Variance parameter estimates and type III tests of fixed effects
(vc_cs = VarCorr(model_cs))
(ftest_cs = joint_tests(model_cs, mode = 'satterthwaite'))

# We could compare these models using likelihood ratio test (since they are nested)
# or via AIC/BIC
anova(model_spt, model_cs)
AIC(model_spt, model_cs)

# Export results to an excel workbook
output = list('F-test' = as.data.frame(ftest_cs), 
              'Var Param Ests' = as.data.frame(vc_cs))
file_out = paste0('Results/', sys, ' SPT Analysis Results.xlsx')
write_xlsx(x = output, path = file_out)



