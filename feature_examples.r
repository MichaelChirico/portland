## features are functions \phi(.) that take as input (x,y,t) pairs and return vectors 
## for simplicity I'm going to do everything in one dimension, let's call it time, but
## label it x since t is a special character by itself in R.
grid = seq(0,2,.01)

## here is a simple feature, equivalent in the regression setting to the regression
## y ~ x + x^2
phi = function(x) {
  return(data.frame(cbind(phi1=x,phi2=x^2)))
}
## what does it look like?
par(mfrow=c(1,2))
plot(grid,phi(grid)$phi1,main="phi1",ty="l")
plot(grid,phi(grid)$phi2,main="phi2",ty="l")

## and here is a different feature, the squared exponential (aka RBF) kernel centered at
## 0.5 and 1.5 with lengthscale .5
psi = function(x) {
  return(data.frame(cbind(psi1=exp(-.5 * (x-.5)^2/.5^2),psi2=exp(-.5 * (x-1.5)^2/.5^2))))
}
plot(grid,psi(grid)[,1],main="psi1",ty="l")
plot(grid,psi(grid)[,2],main="psi2",ty="l")

## now what does it mean to use these features in a regression problem?
## let's generate some fake data and try to fit it using linear regression with these
## features.
x = runif(100,0,2)
y = cos(x * 2 * pi) + rnorm(100) * .1
par(mfrow=c(1,1))
plot(x,y,main="fake data")

## first we'll just do linear regression, which of course fails terribly
data = data.frame(x,y)
fit=lm(y ~ x,data=data)
lines(grid,predict(fit,data.frame(x=grid)),col="red")

## now let's create a dataset with our features
data1 = cbind(y,phi(x))
data2 = cbind(y,psi(x))
fit1 = lm(y ~ phi1 + phi2,data=data1)
fit2 = lm(y ~ psi1,data=data2)
lines(grid,predict(fit1,phi(grid)),col="purple")
lines(grid,predict(fit2,psi(grid)),col="orange")

## not a very good fit with just two...what if we add a bunch more features, centering
## RBF kernels at a grid of locations
psi2 = function(x,u=seq(0,2,.1)) {
  d = outer(x,u,"-")
  return(as.data.frame(exp(-.5 * (d)^2/.5^2)))
}
df = psi2(grid)
# here's what the features look like, all on top of each other
plot(grid,df[,1],ty="l")
for(i in 2:ncol(df))
  lines(grid,df[,i])
data3 = as.data.frame(cbind(y,psi2(x)))
fit3 = lm(y ~ .,data=data3)
summary(fit3) # the system is overdetermined, so R does something ...  
plot(x,y,main="fake data")
lines(grid,predict(fit3,df),col="orange") # a perfect (over)fit
# how does it generalize?
df2 = psi2(seq(-1,3,.01))
plot(x,y,main="fake data",xlim=c(-1,3),ylim=c(-150,2))

lines(seq(-1,3,.01),predict(fit3,df2),col="orange") # oy...regularization needed!

## now to Mike's question about generating random functions...
## with a set of features we can randomly weight them using draws from a 
## normal distribution. let's look at random functions using phi, psi, and psi2
par(mfrow=c(2,2))
for(i in 1:4) plot(grid,(data.matrix(phi(grid))  %*% rnorm(2)),ty="l",ylim=c(-12,12))
for(i in 1:4) plot(grid,(data.matrix(psi(grid))  %*% rnorm(2)),ty="l",ylim=c(-2,2))
for(i in 1:4) plot(grid,(data.matrix(df)  %*% rnorm(21)),ty="l",ylim=c(-6,6))

## and finally, why are we using RBF features when we could be using cos/sin features?
## no particular reason! RBF networks have a long history in machine learning. they don't
## particularly scale well with dimensionality, but our problem is 3 dimensional, so that's fine.
## but just to see how it works, here's a sin/cos featurization:

freq = rnorm(21)
rff = function(x) {
  df = cbind(cos(x %o% freq),sin(x %o% freq))
  return(as.data.frame(df))
}
df = rff(grid)
# here's what the features look like, all on top of each other
plot(grid,df[,1],ty="l")
for(i in 2:ncol(df))
  lines(grid,df[,i])
data4 = as.data.frame(cbind(y,rff(x)))
fit4 = lm(y ~ .,data=data4)
summary(fit4)  ## notice that the coefficients are huge! regularization is important here.
plot(x,y,main="fake data")
lines(grid,predict(fit4,df),col="orange") # a perfect fit...but it's definitely overfitting!
# how does it generalize?
df = rff(seq(-1,3,.01))
plot(x,y,main="fake data",xlim=c(-1,3),ylim=c(-4,4))
lines(seq(-1,3,.01),predict(fit4,df),col="orange") # oy...regularization needed!

