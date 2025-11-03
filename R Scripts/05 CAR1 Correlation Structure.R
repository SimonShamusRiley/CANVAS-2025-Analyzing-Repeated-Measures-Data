#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 5: Not Applicable for R Users                                           #
#==============================================================================#

# While the SAS users are looking at PROC HPMIXED, we can instead look at the 
# use of other correlation structures:

# Still limiting the analysis to one system and time point
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

# If we wanted to iterate through the analysis of all the 
# systems, we can do so with a for loop, but when doing this
# it is also helpful to set up error handling procedures, so
# the the loop isn't broken if there are convergence or other
# issues during one of the model fitting. 

# Create error catcher
tryCatch.W.E <- function(expr){
  W <- NULL
  w.handler <- function(w) { # warning handler
    W <<- w
    invokeRestart("muffleWarning")
  }
  list(value = withCallingHandlers(tryCatch(expr, error = function(e) e),
                                   warning = w.handler),
       warning = W)
}

# Extract system names and create list to save output
systems = unique(soilN$system)
model_list = list()

for (s in systems) {
  print(s)
  model_list[[s]] <- tryCatch.W.E({
    lme(
    fixed = response ~ trt*year*D_class, 
    data = filter(soilN, system == s & DAP == dap),
    random = ~ 1|block/trt/year,
    correlation = corCAR1(form = ~ depth|block/trt/year), 
    weights = varIdent(form = ~1|D_class)
  )})
}

model_list$Tile$value # Either a fitted model or an error message

