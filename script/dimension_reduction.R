library(tidyverse)
library(ggpubr)
library(Rtsne)

df = read.csv("./df.csv")
X = as.matrix(df[,-c(1,2)])

## PCA
pca <- prcomp(X)
summary(pca)

df_pca <- pca$x %>% as_tibble()
df_pca = cbind(author = df$AUTHOR, df_pca)

p12_pca = ggplot(df_pca, aes(PC1,PC2))+
  geom_point(aes(color = author)) +
  theme_light()+
  theme(legend.position = c(0.9, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p13_pca =ggplot(df_pca, aes(PC1,PC3))+
  geom_point(aes(color = author)) +
  theme_light()+
  theme(legend.position = c(0.9, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p23_pca =ggplot(df_pca, aes(PC2,PC3))+
  geom_point(aes(color = author))+
  theme_light()+
  theme(legend.position = c(0.9, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p_pca = ggarrange(p12_pca, p13_pca, p23_pca, ncol = 3, nrow = 1)
ggsave(p_pca, filename = "./results/PCA.pdf", width = 12, height = 4)

## t-SNE
set.seed(1104)
tsne = Rtsne(X, dims = 3)

tsne_df <- tsne$Y %>% 
  as.data.frame() %>%
  rename(tSNE1="V1",
         tSNE2="V2",
         tSNE3="V3")
tsne_df = cbind(author = df$AUTHOR, tsne_df)

p12_tsne = ggplot(tsne_df, aes(tSNE1,tSNE2))+
  geom_point(aes(color = author)) +
  theme_light()+
  theme(legend.position = c(0.2, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p13_tsne =ggplot(tsne_df, aes(tSNE1,tSNE3))+
  geom_point(aes(color = author)) +
  theme_light()+
  theme(legend.position = c(0.2, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p23_tsne =ggplot(tsne_df, aes(tSNE2,tSNE3)) +
  geom_point(aes(color = author)) +
  theme_light()+
  theme(legend.position = c(0.2, 0.2), 
        legend.background = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA))

p_tsne = ggarrange(p12_tsne, p13_tsne, p23_tsne, ncol = 3, nrow = 1)
ggsave(p_tsne, filename = "./results/tSNE.pdf", width = 12, height = 4)

