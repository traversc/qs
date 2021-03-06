library(qs12)
library(qs131)
library(qs141)
library(qs151)
library(qs161)
library(qs173)
library(qs183)
library(qs191)
library(qs202)
library(qs212)
library(qs236)
library(qs)
library(dplyr)

dataframeGen <- function() {
  nr <- 1e6
  data.frame(a=rnorm(nr), 
             b=rpois(100,nr),
             c=sample(starnames[["IAU Name"]],nr,T), 
             d=factor(sample(state.name,nr,T)), stringsAsFactors = F)
}

listGen <- function() {
  as.list(sample(1e6))
}

grid <- expand.grid(ver = c(22:24), data = c("list", "dataframe"), 
                    preset = c("uncompressed", "fast", "balanced", "high", "archive"), 
                    reps=1:20, stringsAsFactors = F) %>% sample_frac(1)

write_time <- numeric(nrow(grid))
read_time <- numeric(nrow(grid))
for(i in 1:nrow(grid)) {
  print(i)
  if(grid$data[i] == "list") {
    x <- listGen()
  } else if(grid$data[i] == "dataframe") {
    x <- dataframeGen()
  }
  if(grid$ver[i] == 14) {
    save <- qs141::qsave
    read <- qs141::qread
  } else if(grid$ver[i] == 15) {
    save <- qs151::qsave
    read <- function(...) qs151::qread(..., use_alt_rep=F)
  } else if(grid$ver[i] == 16) {
    save <- qs161::qsave
    read <- function(...) qs161::qread(..., use_alt_rep=F)
  } else if(grid$ver[i] == 17) {
    save <- function(...) qs173::qsave(..., check_hash = F)
    read <- qs173::qread
  } else if(grid$ver[i] == 18) {
    save <- function(...) qs183::qsave(..., check_hash = F)
    read <- qs183::qread
  } else if(grid$ver[i] == 19) {
    save <- function(...) qs191::qsave(..., check_hash = F)
    read <- qs191::qread
  } else if(grid$ver[i] == 20) {
    save <- function(...) qs202::qsave(..., check_hash = F)
    read <- qs202::qread
  } else if(grid$ver[i] == 21) {
    save <- function(...) qs212::qsave(..., check_hash = F)
    read <- qs212::qread
  } else if(grid$ver[i] == 22) {
    save <- function(...) qs221::qsave(..., check_hash = F)
    read <- qs221::qread
  } else if(grid$ver[i] == 23) {
    save <- function(...) qs236::qsave(..., check_hash = F)
    read <- qs236::qread
  } else if(grid$ver[i] == 24) {
    save <- function(...) qs::qsave(..., check_hash = F)
    read <- qs::qread
  }
  file <- tempfile()
  write_time[i] <- if(grid$preset[i] == "archive") {
    if(grid$ver[i] <= 15) next;
    time <- as.numeric(Sys.time())
    save(x, file, preset = "custom", algorithm = "zstd_stream", compress_level=5)
    1000 * (as.numeric(Sys.time()) - time)
  } else if(grid$preset[i] == "high") {
    time <- as.numeric(Sys.time())
    save(x, file, preset = "custom", algorithm = "zstd", compress_level=5)
    1000 * (as.numeric(Sys.time()) - time)
  } else if(grid$preset[i] == "balanced") {
    time <- as.numeric(Sys.time())
    save(x, file, preset = "custom", algorithm = "lz4", compress_level=1)
    1000 * (as.numeric(Sys.time()) - time)
  } else if(grid$preset[i] == "fast") {
    time <- as.numeric(Sys.time())
    save(x, file, preset = "custom", algorithm = "lz4", compress_level=100)
    1000 * (as.numeric(Sys.time()) - time)
  } else if(grid$preset[i] == "uncompressed") {
    if(grid$ver[i] <= 17) next;
    time <- as.numeric(Sys.time())
    save(x, file, preset = "custom", algorithm = "uncompressed")
    1000 * (as.numeric(Sys.time()) - time)
  }
  rm(x); gc()
  time <- as.numeric(Sys.time())
  x <- read(file)
  read_time[i] <- 1000 * (as.numeric(Sys.time()) - time)
  rm(x); gc()
  unlink(file)
}

grid$write_time <- write_time
grid$read_time <- read_time

gs <- grid %>% group_by(data, ver, preset) %>%
  summarize(n=n(), mean_read_time = mean(read_time),
            median_read_time = median(read_time),
            mean_write_time = mean(write_time),
            median_write_time = median(write_time)) %>% as.data.frame
print(gs)

library(patchwork)
library(ggplot2)

g1 <- ggplot(grid, aes(x = preset, fill = as.factor(ver), group=as.factor(ver), y = read_time)) +
  geom_bar(stat = "summary", fun.y = "mean", position = "dodge", color = "black") +
  # geom_point(position = position_dodge(width=0.9), shape=21, fill = NA) +
  facet_wrap(~data, scales = "free", ncol=2) +
  theme_bw() + theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 1)) +
  trqwe:::gg_rotate_xlabels(angle=45, vjust=1) +
  labs(fill = "Version", title = "read benchmarks")

g2 <- ggplot(grid, aes(x = preset, fill = as.factor(ver),  group=as.factor(ver), y = write_time)) +
  geom_bar(stat = "summary", fun.y = "mean", position = "dodge", color = "black") +
  geom_point(position = position_dodge(width=.9), shape=21, fill = NA, alpha=0.5) +
  facet_wrap(~data, scales = "free", ncol=2) +
  theme_bw() + theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 1)) +
  trqwe:::gg_rotate_xlabels(angle=45, vjust=1) +
  labs(fill = "Version", title = "write benchmarks")

g1 + g2 + plot_layout(nrow=2, ncol=1)
