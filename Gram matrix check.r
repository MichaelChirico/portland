library(rstan)
match.cols<-function(val,n){
	col<-data.frame(val=seq(min(val),max(val),length.out=n),col=rev(terrain.colors(n)))
	out<-rep(NA,length(col))
	for(i in 1:length(val)){
		out[i]<-as.character(col[which.min(abs(col$val-val[i])),'col'])
	}	
	return(out)
}


library(RandomFields)
n_train <- 200; set.seed(123)
x_train <- cbind(s1=sample(1:n_train/n_train-0.5/n_train)^2, s2=sample(1:n_train/n_train-0.5/n_train)^2)
D=2

#model <- RMgauss(scale=1.4,var=2.2)
#y<-RFsimulate(model, x=x_train[,1],y=x_train[,2])$variable1 + rnorm

#KK<-RFcovmatrix(model,x_train)
Kfn = function(x, l=1, sigmaf=1){
    sigmaf * exp( -0.5* (1/(l)) * as.matrix(dist(x, upper=T, diag=T)^2) ) + as.matrix(diag(1e-6,nrow(x)))
}

l=0.04
ss=40
KK<-Kfn(x_train,l,ss)

y<-rnorm(nrow(KK))%*%chol(KK)
y_train=y

plot(x_train,col=match.cols(y,1000),pch=16)


features<-c(100,200,300,400,500,1000,3000,5000)
mat<-matrix(ncol=3,nrow=length(features))
for(xx in 1:length(features)){
	k <- features[xx];D=2

	library(randtoolbox)
	bw<-1/(sqrt(l))
	omega_qmc<-t(halton(k,D))
	omega_rff<-t(cbind(rnorm(k),rnorm(k)))
	
	xxprojected <- x_train%*%qnorm(omega_qmc)
	f.qmc<- sqrt(ss/k)*cbind(cos(xxprojected*bw),sin(xxprojected*bw))

	Kqmc<-(f.qmc)%*%t(f.qmc)
	
	xxprojected <- x_train%*%(omega_rff)
	f.rff<- sqrt(ss/k)*cbind(cos(xxprojected*bw),sin(xxprojected*bw))

	Krff<-(f.rff)%*%t(f.rff)

	mat[xx,1]=k
	mat[xx,2]= norm(KK-Krff)/norm(KK)
	mat[xx,3]= norm(KK-Kqmc)/norm(KK)
}

plot(mat[,1],mat[,2],type='b',col='red',ylim=c(min(mat[,2:3]),max(mat[,2:3])))
lines(mat[,1],mat[,3],type='b',col='blue')

#plot(KK,Kqmc)