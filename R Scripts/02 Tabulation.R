#==============================================================================#
# CANVAS 2025 Repeated Measures Workshop                                       #
# --------------------------------------                                       #
# Step 2: Tabulation (Data exploration & validation)                           #
#==============================================================================#

# First simple count by resp_name
soilN %>%
  count(resp_name)

# Second: count by resp_name and system
soilN %>%
  count(resp_name, system)

# Third: count by resp_name, depth and system
soilN %>%
  count(resp_name,depth, system)

# Fourth: count by resp_name, year, DAP, depth and system
soilN %>%
  count(resp_name,year,DAP,depth, system) %>%
  pivot_wider(names_from = 'system', values_from = 'n')

# Data quality check: do the values make sense? 
soilN %>% 
  group_by(resp_name, system, year) |> 
  summarise(min = min(response), 
            mean = mean(response), 
            max = max(response))





