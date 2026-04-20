calculate_hydraulic <- function(theta_s,theta_r,alpha,n) {
  h_fc     <- 10^2.5
  theta_fc <- theta_r +
    (theta_s - theta_r) /
    (1 + (alpha * h_fc)^n)^(1 - 1/n)
  
  h_pwp     <- 10^4.2
  theta_pwp <- theta_r +
    (theta_s - theta_r) /
    (1 + (alpha * h_pwp)^n)^(1 - 1/n)
  
  paw_total <- theta_fc - theta_pwp
  
  return(data.frame(
    theta_fc  = theta_fc,
    theta_pwp = theta_pwp,
    paw       = paw_total
  ))
}