## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
withr:::defer({Sys.unsetenv('EDP_PROFILE')}, parent.frame(n=2))

