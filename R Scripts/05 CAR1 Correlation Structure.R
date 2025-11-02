#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 5: Not Applicable for R Users                                           #
#==============================================================================#

# While the SAS users are looking at PROC HPMIXED, we can instead look at the 
# use of other correlation structures:

sys <- 'Drip'
dap <- '1'

# Here, we are using a continuous 1st order autoregressive correlation  
# structure, an providing the depth (numerical value) as a covariate. This
# is generalization of the AR(1) structure for evenly-spaced intervals
model_car1 <- lme(
  fixed = response ~ trt*year*D_class, 
  data = filter(soilN, system == sys & DAP == dap),
  random = ~ 1|block/trt/year,
  correlation = corCAR1(form = ~ depth|block/trt/year), 
  weights = varIdent(form = ~1|D_class)
)

# Estimated correlation:
model_car1$modelStruct$corStruct
