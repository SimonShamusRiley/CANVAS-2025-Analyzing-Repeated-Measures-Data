#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 8: Incorportating System, and Modelling Year, Depth and DAP as Repeated #
#==============================================================================#

# Combined analysis of systems
# Unfortunately, the model will not converge, and some form of
# model simplification will be required to analyse systems together
model_un4 <- lme(
  fixed = response ~ system*trt*year*D_class*DAP,
  data = soilN,
  random = list(block = ~1, trt = ~1, 
                trt = ~ year - 1,
                year = ~ DAP - 1),
  correlation = corSymm(form = ~ 1|block/trt/trt/year/DAP),
  weights = varIdent(form = ~1|D_class))

