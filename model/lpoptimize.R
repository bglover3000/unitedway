
# Contributors: Michael Lane
# This is linear constraint optimizer we are going to use. Because  
#we have is a close form solution and our function is linear we can
#use the LP Solver library.  However, we have to re-write our "UW_R_Script_final.R"
#(and pop.cwbcalculate) in linear form, then run the optimizer. 
#df/dx = all the derivatives of the variables added up = add up all 1/7,1/3,1/4 
#df/dx = (7/7+3/3+4/4)/3 = 3/3 = 1
# Deliverable: The goal for this month is to get the linear optimizer running for the overall
#average weighted equally by each county.  We cannot use the simple overall average
#for testing because our Z-score are calculated using that average.
# Goal: A Z score of 0.33886 or CWB_index = .689 is the goal!
df2 <- as.data.frame(read.csv("overall constrants.csv", skip = 2, row.names = 1))

# Load in the original script.  We need df0 and dfindex from it
source('model/UW_R_Script_final.R')
# Load in the coeffcients. I have written the algorithm
source('model/coefficents.R')
# coefficents.R contains some test script and you don't need the excess stuff
rm(CWBZ,CWB1,CWB2,CWB3,dfNorm) 

########### ---- Linear Optimizer TEST CODE ---- ###########
Value = .689
maxCWB_Z = max(df_index$CWB_Z)
minCWB_Z = min(df_index$CWB_Z)
Value = (.689*(maxCWB_Z - minCWB_Z)) + minCWB_Z

df2 <- as.data.frame(read.csv("~/data/overall constrants.csv", skip = 2, row.names = 1))


library(lpSolve)
library(lpSolveAPI)
# Set the number of vars
model <- make.lp(0, 3)
# Define the object function: for Minimize, use -ve
set.objfn(model, c(1/(7*3), 1/(3*3), 1/(4*3))) #Replica of Child well being index but by sub-indexes
# Add the constraints
add.constraint(model, c(1/(7*3), 1/(3*3), 1/(4*3)), "=", Value)
# Set the upper and lower bounds
set.bounds(model, lower=c(0.0, 0.0, 0.0), upper=c(1.0, 1.0, 1.0)) #***We are using for constraints
# Compute the optimized model
solve(model) 
# Get the value of the optimized parameters
get.variables(model) 
# Get the value of the objective function
get.objective(model)
# Get the value of the constraint
get.constraints(model) 
