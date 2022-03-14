library(future)
library(furrr)

pid <- Sys.getpid()
pid

plan(sequential)
future_map(c("a","b","c"), function(i){
  test <- Sys.getpid()
  list(i, test)
})

plan(multisession)


future_map(c("a","b","c"), function(i){
  test <- Sys.getpid()
  list(i, test)
})
