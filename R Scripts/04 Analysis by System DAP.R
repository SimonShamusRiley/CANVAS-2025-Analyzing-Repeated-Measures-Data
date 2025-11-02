#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 4: Modelling by System and DAP, with Depth Repeated                     #
#==============================================================================#

sys <- 'Drip'
dap <- '1'

# To be able to model residual correlations or heteroscedasticity, we switch to 
# the nlme package. We also switch to using the simplified formula for only
# nested random effects.
model_un <- lme(
  fixed = response ~ trt*year*D_class, 
  data = filter(soilN, system == sys & DAP == dap),
  random = ~ 1|block/trt/year,
  correlation = corSymm(form = ~ 1|block/trt/year), 
  weights = varIdent(form = ~1|D_class)
)

# When modelling correlation or variance structures, we want to use
# normalized residuals in our diagnostic plots, but to do this 
# we need to "manually" calculated residual and fitted values.
# Note that the heteroscedasticity has been eliminated
res_un = resid(model_un, type = 'normalized')
fit_un = fitted(model_un)
resid_auxpanel(res_un, fit_un)

(vc_un = VarCorr(model_un)) # Variance parameter estimates

# Visualizing  the UN matrix
extract.lme.cov2(model_un)[[1]][[1]][1:3, 1:3]  # Depths within an plot
View(extract.lme.cov2(model_un)[[1]][[1]])      # All observations in block 1

# For purely nested random effects in an lme model, joint_tests() will 
# correctly calculate denDF (but not for crossed random effects, for which
# the best we can do is satterthwaite)
(ftest_un = joint_tests(model_un))

# If we wanted to save those output:
output = list('F test' = as.data.frame(ftest_un), 
              'Var Param Ests' = as.data.frame(vc_un))
file_out = paste0('Results/', sys, ' DAP ', dap, ' Analysis Results.xlsx')
write_xlsx(x = output, path = file_out)
