#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 7: Modelling Depth and DAP as Repeated                                  #
#==============================================================================#

# Limit analysis to one system
sys <- 'Drip'

# This takes several minutes to fit on my machine, so I've 
# commented it out, and the fitted model can be read in below.

# There are several important points to note here. First, we have
# switched to using a list of one sided formulas to specify the random effects.
# When a list is used here, the nesting structure is taken from the ordering of
# the terms. Second, G-side modelling of an unstructured correlation among DAPs
# requires that the year term be duplicated: the first year term (year = ~1) is
# the random effect for year, and the second (year = ~ DAP-1) is the correlation
# among DAPs within each year. Secondly, in order for the model to converge, 
# additional iterations are needed, leading to the inclusion
# of the control = lmeControl() argument. 

# model_un3 <- lme(
#   fixed = response ~ trt*year*D_class*DAP,
#   data = filter(soilN, system == sys),
#   random = list(block = ~1, trt = ~1, year = ~1,
#                 year = ~ DAP-1),
#   correlation = corSymm(form = ~ 1|block/trt/year/year/DAP),
#   weights = varIdent(form = ~1|D_class),
#   control = lmeControl(maxIter = 100, msMaxIter = 100, niterEM = 50)
# )
# saveRDS(model_un3, 'Results/Drip UN Model for DAP & Depth.rds')

model_un3 <- readRDS('Results/Drip UN Model for DAP & Depth.rds')

# Check residuals
res_un3 <- resid(model_un3, type = 'normalized')
fit_un3 <- fitted(model_un3)
resid_auxpanel(res_un3, fit_un3)

(vc_un3 <- VarCorr(model_un3)) # Variance parameter estimates

# For purely nested random effects in an lme model, joint_tests() will 
# correctly calculate denDF (but not for crossed random effects, for which
# the best we can do is satterthwaite)
(ftest_un3 <- joint_tests(model_un3))

# If we wanted to generate estimates, we do so with emmeans, 
# for example:
(emm1 = emmeans(model_un3, ~ trt|D_class))

# If we wanted to save those output:
output <- list('F test' = as.data.frame(ftest_un3), 
              'Var Param Ests' = as.data.frame(vc_un3), 
              'Ests' = as.data.frame(emm1))
file_out <- paste0('Results/', sys, ' Analysis Results.xlsx')
write_xlsx(x = output, path = file_out)
