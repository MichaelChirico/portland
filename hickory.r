library(spatstat)
library(ggplot2)

# the Lansing dataset gives the locations of different types of trees in a forest in Michigan
hickory <- split(lansing)$hickory

# get the locations of the trees for plotting later
hf = as.data.frame(hickory)

# how much should we discretize the dataset?
gridsize = .01
data = data.matrix(as.data.frame(pixellate.ppp(hickory,eps=gridsize)))
gridarea = gridsize^2
print(nrow(data)) # number of rows in our discretized dataset.

# these are parameters for the featurization
l = .03 # lengthscale
k = 200 # number of random features
D = 2 # dimensionality

library(randtoolbox)
bw<-1/l #sqrt(l)
omega_rff<-t(cbind(rnorm(k),rnorm(k)))

xxprojected <- data[,1:2]%*%(omega_rff)
f.rff<- sqrt(1/k)*cbind(cos(xxprojected*bw),sin(xxprojected*bw))

make.plot=function(df,include.points=T) {
  g = ggplot(df, aes(x=x,y=y))
  g = g + geom_tile(aes(fill=yhat))
  if(include.points)
    g = g + geom_point(data=hf,color="white",alpha=.5,size=.5)
  return(g)
}
print(range(data[,3]/gridarea))

### use glmnet to fit
library(glmnet)
# this call takes 70 seconds without a parallel backend
ptm = proc.time()
fit=cv.glmnet(f.rff,data[,3]/gridarea,family="poisson",alpha=0)  # alpha = 0 is ridge regression, no lasso penalty

# to enable parallelization:
#library(doMC); registerDoMC(cores=16)
#fit=cv.glmnet(f.rff,data[,3]/gridarea,family="poisson",alpha=0,parallel=T)  # alpha = 0 is ridge regression, no lasso penalty

proc.time() - ptm

plot(fit) # in the plot, higher lambda (towards the right) means less regularization

df = data.frame(data)
df$yhat=predict(fit,f.rff,type="response",s="lambda.min") # make predictions at the minimum value found with crossvalidation
make.plot(df,include.points=T) # plot the fitted values
plot(density(hickory,sigma = .03)) # kernel density estimate for comparison

### use vw...
## step 1: output a properly formatted file for vw
featurize = function(x,y) {
  features = paste0(paste0("c",1:length(x)),":",x,collapse=" ")
  return(sprintf("%d |centroid %s",round(y/gridarea), features))
}


sink("hickory.vw")
for(i in 1:nrow(f.rff)) {
  cat(featurize(f.rff[i,],data[i,3]/gridarea))
  cat("\n")
}
sink()

### run vw:
'
rm hickory.vw.cache
vw --loss_function poisson --l2 1e-4 --l1 1e-5 \
    hickory.vw --cache_file hickory.vw.cache --passes 200 -f hickory.model 
vw -t -i hickory.model -p hickory_yhat.txt hickory.vw --loss_function poisson 
head hickory_yhat.txt
'

df2 = data.frame(data)
df2$yhat = (read.table("hickory_yhat.txt")[,1])
range(exp(df2$yhat))
make.plot(df2,include.points=T) # plot the fitted values
plot(density(hickory,sigma = .03)) # kernel density estimate for comparison
plot(df$yhat,df2$yhat)

# 
# g = ggplot(df, aes(x=x,y=y))
# g = g + geom_tile(aes(fill=value))
# g = g + geom_point(data=hf,color="red")
# print(g)
