#-------------------------------------------------------------------------------*
#https://www.r-bloggers.com/what-are-the-best-machine-learning-packages-in-r/
#-------------------------------------------------------------------------------
#(1)Libreria "mice" para controlar valores perdidos
#-------------------------------------------------------------------------------*
#simulamos valores perdidos
dataset <- data.frame(var1=rnorm(20,0,1), var2=rnorm(20,5,1))
dataset[c(2,5,7,10),1] <- NA
dataset[c(4,8,19),2] <- NA
summary(dataset)
#completa valores perdidos
require(mice)
dataset2 <- mice(dataset)
dataset2<-complete(dataset2)
summary(dataset2)
#-------------------------------------------------------------------------------*
#(2)RPART package
#-------------------------------------------------------------------------------*
#libreria "rpart" para árboles de decision de clasificación y de regresión
rpart_tree <- rpart(formula = Species~., data=iris, method = "class")
summary(rpart_tree)
print(rpart_tree)
#-------------------------------------------------------------------------------*
#(3.1)PARTYKIT package
#-------------------------------------------------------------------------------*
#install.packages("partykit")
detach("package:party", unload=TRUE) #hay conflicto entre partys
library(partykit)
partykit_tree <- ctree(formula=Species~. , data = iris)
plot(partykit_tree)
print(partykit_tree)
#extrayendo la lista de reglas
partykit:::.list.rules.party(partykit_tree)
#-------------------------------------------------------------------------------*
#(3.2)REE party package
#-------------------------------------------------------------------------------*
detach("package:partykit", unload=TRUE) #hay conflicto entre partys
library(party)
party_tree <- ctree(formula=Species~. , data = iris)
plot(party_tree)
print(party_tree)
### Identificando los nodos del arbol
nodes(party_tree, unique(where(party_tree)))
#distribution de las respuestas en los nodos del arbol
plot(iris$Species ~ as.factor(where(party_tree)))
#-------------------------------------------------------------------------------*
#CARET: Classification And Regression Training
#-------------------------------------------------------------------------------*
library(caret)
#Notar que la variable a expliar es numerica
lm_model <- train(Sepal.Length~Sepal.Width + Petal.Length + Petal.Width, data=iris, method = "lm")
summary(lm_model)
#predicciones
Sepal.Length.Est<-predict(lm_model,newdata=iris)
data.frame(iris$Sepal.Length,Sepal.Length.Est)

#CARET: Haciendo un modelo con data de train y test luego comparar predicciones con matriz de confusión
set.seed(42)
index <- createDataPartition(iris$Sepal.Length, p = 0.7, list = FALSE)
train_iris <- iris[index, ] #nrow(train_iris)
test_iris  <- iris[-index, ] #nrow(test_iris)
lm_model <- train(Sepal.Length~Sepal.Width + Petal.Length + Petal.Width, data=train_iris, method = "lm")
summary(lm_model)
Sepal.Length.Est<-predict(lm_model,newdata=test_iris)
data.frame(test_iris$Sepal.Length,Sepal.Length.Est,test_iris$Sepal.Length-Sepal.Length.Est)
#-------------------------------------------------------------------------------*
#randomForest: Let's combine multiple trees to build our own fores
#-------------------------------------------------------------------------------*
library(randomForest)
Rf_fit<-randomForest(formula=Species~., data=iris)
print(Rf_fit)
class(Rf_fit)
importance(Rf_fit)
#-------------------------------------------------------------------------------*
#nnet: It's all about hidden layers
#-------------------------------------------------------------------------------*
library(nnet)
nnet_model <- nnet(Species~., data=iris, size = 10)
plot.nnet=(nnet_model)
#-------------------------------------------------------------------------------*
#e1071: Let the vectors support your model
#-------------------------------------------------------------------------------*
library(e1071)
svm_model <- svm(Species ~Sepal.Length + Sepal.Width, data=iris)
plot(svm_model, data = iris[,c(1,2,5)])

