fit_unimodal_vg <- function(data) {
  data <- data %>% mutate(h = 10^pF)
  
  theta_s_total <- max(data$VWC, na.rm = TRUE) * 0.95
  theta_r_start <- min(data$VWC, na.rm = TRUE) * 1.05
  
  model_uni <- nlsLM(
    VWC ~ theta_r + (theta_s - theta_r) / (1 + (alpha * h)^n)^(1 - 1/n),
    data = data,
    start = list(
      theta_s = theta_s_total,
      theta_r = theta_r_start,
      alpha   = 0.02,
      n       = 1.5
    ),
    lower   = c(theta_s = theta_r_start, theta_r = 0, alpha = 0.001, n = 1.1),
    upper   = c(theta_s = 60,            theta_r = theta_s_total, alpha = 1, n = 10),
    control = nls.lm.control(maxiter = 200)
  )
  
  params_uni   <- coef(model_uni)
  fitted_vals  <- predict(model_uni)
  residuals_uni <- residuals(model_uni)
  rsq_uni      <- 1 - sum(residuals_uni^2) / sum((data$VWC - mean(data$VWC))^2)
  rmse_uni     <- sqrt(mean(residuals_uni^2))
  aic_uni      <- AIC(model_uni)
  
  return(list(
    model      = model_uni,
    params     = params_uni,
    rsq        = rsq_uni,
    rmse       = rmse_uni,
    aic        = aic_uni,
    model_type = "unimodal"
  ))
}