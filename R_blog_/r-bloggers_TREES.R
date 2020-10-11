#-------------------------------------------------------------------------------*
#https://www.r-bloggers.com/a-brief-tour-of-the-trees-and-forests/
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------*
#(1) RPART: This package includes several example sets of data that can 
#be used for recursive partitioning and regression trees
#-------------------------------------------------------------------------------*

library(rpart)

frmla = Species ~Sepal.Length + Sepal.Width

fit = rpart(frmla, method="class", iris)

printcp(fit) # display the results
plotcp(fit) # visualize cross-validation results
summary(fit) # detailed summary of splits
# plot tree
plot(fit, uniform=TRUE, main="Classification Tree for Chemicals")
text(fit, use.n=TRUE, all=TRUE, cex=.8)
# tabulate some of the data
table(subset(iris, Sepal.Width>=3)$Species)

#-------------------------------------------------------------------------------*
#(2) TREE: This is the primary R package for classification and regression trees. 
#-------------------------------------------------------------------------------*
#install.packages("tree")
library(tree)

raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width

tr = tree(frmla, data=raw)
summary(tr)
plot(tr); text(tr)
#-------------------------------------------------------------------------------*
#(2) PARTY: Conditional trees 
#-------------------------------------------------------------------------------*
# PARTY package
detach("package:partykit", unload=TRUE) #hay conflicto con partykit
library(party)

raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width

(ct = ctree(frmla, data = raw))

plot(ct, main="Conditional Inference Tree")
#Table of prediction errors
table(predict(ct), iris$Species)
# Estimated class probabilities
tr.pred = predict(ct, newdata=raw, type="prob")

#-------------------------------------------------------------------------------*
#MAPTREE is a very good at graphing, pruning data from hierarchical clustering, and CART models.
#-------------------------------------------------------------------------------*
# MAPTREE
#install.packages("maptree")
library(maptree)
library(cluster)

raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width

fit = rpart(frmla, method="class", iris)

draw.tree( fit,
           nodeinfo=TRUE, units="species",
           cases="cells", digits=0)

#-------------------------------------------------------------------------------*
#EVTREE (Evoluationary Learning)
#-------------------------------------------------------------------------------*
#install.packages("evtree")
#detach("package:party",unload=TRUE) #hay conflicto con partykit
library(evtree)
raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width
ev.raw = evtree(frmla, data=raw)
plot(ev.raw)
table(predict(ev.raw), iris$Species)
1-mean(predict(ev.raw) == iris$Species)
#-------------------------------------------------------------------------------*
#randomForest: Random forests are very good in that it is an ensemble learning 
# method used for classification and regression
# It uses multiple models for better performance that just using a single tree model.
#-------------------------------------------------------------------------------*
library(randomForest)
raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width
fit.rf = randomForest(frmla, data=raw)
print(fit.rf)
importance(fit.rf)
plot(fit.rf)
#??
plot( importance(fit.rf), lty=2, pch=16)
lines(importance(fit.rf))
imp = importance(fit.rf)
impvar = rownames(imp)[order(imp[, 1], decreasing=TRUE)]
#??
op = par(mfrow=c(1, 3))
for (i in seq_along(impvar)) {
  partialPlot(fit.rf, raw, impvar[i], xlab=impvar[i],
              main=paste("Partial Dependence on", impvar[i]),
              ylim=c(0, 1))}

#-------------------------------------------------------------------------------*
#varSelRF: This can be used for further variable selection procedure using random forests.  
#It implements both backward stepwise elimination as well as selection based on the importance spectrum.  
#This data uses randomly generated data so the correlation matrix can set so that 
#the first variable is strongly correlated and the other variables are less so.
#-------------------------------------------------------------------------------*
#install.packages("varSelRF")
library(varSelRF)
x = matrix(rnorm(25 * 30), ncol = 30)
x[1:10, 1:2] = x[1:10, 1:2] + 3
cl = factor(c(rep("A", 10), rep("B", 15)))
rf.vs1 = varSelRF(x, cl, ntree = 200, ntreeIterat = 100,
                  vars.drop.frac = 0.2)

rf.vs1
plot(rf.vs1)

## Example of importance function show that forcing x1 to be the most important
## while create secondary variables that is related to x1.
x1=rnorm(500)
x2=rnorm(500,x1,1)
y=runif(1,1,10)*x1+rnorm(500,0,.5)
my.df=data.frame(y,x1,x2,x3=rnorm(500),x4=rnorm(500),x5=rnorm(500))
rf1 = randomForest(y~., data=my.df, mtry=2, ntree=50, importance=TRUE)
importance(rf1)
cor(my.df)

#-------------------------------------------------------------------------------*
#REEMtree:This package is useful for longitudinal studies where random effects exist.
#-------------------------------------------------------------------------------*
#install.packages("REEMtree")
help(REEMtree)
library(REEMtree)

data(simpleREEMdata)
REEMresult<-REEMtree(Y~D+t+X, data=simpleREEMdata, random=~1|ID)
plot(REEMresult)

#-------------------------------------------------------------------------------*
#CORElearn:This is a great package that contain many different machine learning algorithms and functions.
#-------------------------------------------------------------------------------*
#install.packages("CORElearn")
library(CORElearn)

raw<-iris
frmla = Species ~Sepal.Length + Sepal.Width
## Random Forests
fit.rand.forest = CoreModel(frmla, data=raw, model="rf", selectionEstimator="MDL", minNodeWeightRF=5, rfNoTrees=100)
plot(fit.rand.forest)

## decision tree with naive Bayes in the leaves
fit.dt = CoreModel(frmla, raw, model="tree", modelType=4)
plot(fit.dt, raw)
#??
airquality.sub = subset(airquality, !is.na(airquality$Ozone))
fit.rt = CoreModel(Ozone~., airquality.sub, model="regTree", modelTypeReg=1)
summary(fit.rt)
plot(fit.rt, airquality.sub, graphType="prototypes")
#??
pred = predict(fit.rt, airquality.sub)
print(pred)
plot(pred)