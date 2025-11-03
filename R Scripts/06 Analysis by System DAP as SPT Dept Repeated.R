#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 6: Modelling DAP as SPT and Depth as Repeated                           #
#==============================================================================#

# Limit analysis to one system
sys <- 'Drip'

# Note that we are now going to switch to specifying the random effects as a 
# list. Be aware that the terms are still nested: the order of the items in 
# the list defines the nesting structure. 
model_un2 <- lme(
  fixed = response ~ trt*year*D_class*DAP,
  data = filter(soilN, system == sys),
  random = list(block = ~1, trt = ~1, year = ~1,
                DAP = ~ 1),
  correlation = corSymm(form = ~ 1|block/trt/year/DAP),
  weights = varIdent(form = ~1|D_class)
)

# Check residuals
res_un2 <- resid(model_un2, type = 'normalized')
fit_un2 <- fitted(model_un2)
resid_auxpanel(res_un2, fit_un2)

# Variance parameter estimates
(vc_un2 <- VarCorr(model_un2)) 

# Type III tests of fixed effects
(ftest_un2 <- joint_tests(model_un2))
