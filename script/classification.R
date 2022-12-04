library(gbm)
library(e1071)
library(tidyverse)
df = read.csv("./df.csv")
X = as.matrix(df[,-c(1,2)])

pca <- prcomp(X)
df_pca <- pca$x %>% as_tibble()
df_pca = cbind(author = df$AUTHOR, df_pca)

pca_sum = data.frame(var = summary(pca)$importance[3,], npc = 1:290)
p_pac_sum = ggplot(data = pca_sum) +
  geom_histogram(aes(x = npc, y = var), stat = "identity", fill="lightblue") +
  scale_x_continuous(breaks = 1:30, limits = c(0.5,30.5)) +
  scale_y_continuous(breaks = (0:10)*0.1, limits = c(0,1)) +
  ylab(label = "Proportion of Variance") +
  xlab(label = "No. PC") +
  theme_light()
ggsave(p_pac_sum, filename = "./results/PCA_variance.pdf", height = 4, width = 8)

## GBM
npc_max = 30
rep = 100
accuracy = numeric(npc_max-1)
for (i in 2:npc_max) {
  use_n_pc = i
  df = df_pca[,c(1:(1+use_n_pc))]
  df$author = as.factor(df$author)
  set.seed(i)
  acc_i = numeric(rep)
  for (j in 1:rep) {
    tts <- runif(nrow(df)) < 0.8
    train <- df %>% filter(tts)
    test <- df %>% filter(!tts)
    
    model <- gbm(author~., data=train, distribution = "multinomial");
    prob <- predict(model, newdata=test, type="response")[,,1]
    label = colnames(prob)
    test_ex <- test %>% 
      mutate(author_pred = ifelse(prob[,1] > prob[,2] & prob[,1] > prob[,3], label[1], ifelse(prob[,2] > prob[,3], label[2], label[3])))
    acc_i[j] = mean(test_ex$author == test_ex$author_pred)
  }
  accuracy[i-1] = mean(acc_i)
}

res = data.frame(npc = 2:30, accuracy = accuracy)
p_acc = ggplot(data = res) +
  geom_line(aes(x = npc, y = accuracy)) +
  scale_x_continuous(breaks = 2:30, limits = c(2,30)) +
  ylab(label = "Accuracy") +
  xlab(label = "No. PC") +
  labs(title = "Accuracy of GBM")+
  theme_light()
ggsave(p_acc, filename = "./results/accuracy_gbm.pdf", height = 4, width = 8)

pdf('./results/Influence.pdf', width = 8, height = 6)
summary(model)
dev.off()

## SVM

npc_max = 30
rep = 100
accuracy = numeric(npc_max-1)
for (i in 2:npc_max) {
  use_n_pc = i
  df = df_pca[,c(1:(1+use_n_pc))]
  df$author = as.factor(df$author)
  set.seed(i)
  acc_i = numeric(rep)
  for (j in 1:rep) {
    tts <- runif(nrow(df)) < 0.8
    train <- df %>% filter(tts)
    test <- df %>% filter(!tts)
    
    model <- svm(author~., data=train);
    prob <- predict(model, newdata=test, type="response")
    test_ex <- test %>% 
      mutate(author_pred = prob)
    acc_i[j] = mean(test_ex$author == test_ex$author_pred)
  }
  accuracy[i-1] = mean(acc_i)
}

res_svm = data.frame(npc = 2:30, accuracy = accuracy)
p_acc_svm = ggplot(data = res_svm) +
  geom_line(aes(x = npc, y = accuracy)) +
  scale_x_continuous(breaks = 2:30, limits = c(2,30)) +
  ylab(label = "Accuracy") +
  xlab(label = "No. PC") +
  labs(title = "Accuracy of SVM")+
  theme_light()
ggsave(p_acc_svm, filename = "./results/accuracy_svm.pdf", height = 4, width = 8)

res$method = "GBM"
res_svm$method = "SVM"
res_all = rbind(res, res_svm)

p_comp = ggplot(data = res_all) +
  geom_line(aes(x = npc, y = accuracy, color = method)) +
  scale_x_continuous(breaks = 2:30, limits = c(2,30)) +
  ylab(label = "Accuracy") +
  xlab(label = "No. PC") +
  labs(title = "Comparison")+
  theme_light() +
  theme(legend.position = c(0.9, 0.5), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))
ggsave(p_comp, filename = "./results/accuracy_conparison.pdf", height = 4, width = 8)
