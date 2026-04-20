
# Van Genuchten SWRC 

# ╱|、
# (˚ˎ 。7  
#  |、˜〵          
#  じしˍ,)ノ

# -------------------------------------------------------------------------
# Fits the unimodal van Genuchten model to soil water retention curve (SWRC)
# data, calculates hydraulic properties (FC, PWP, PAW), and produces a swrc plot
#
# Required packages: readxl, minpack.lm,  tidyverse
# Data: anonymous data provides by Cristina Contreras cristina.contreras@uc.cl
# Code: Sara Acevedo + Claude Anthropic Sonnet 4.5 
# -------------------------------------------------------------------------

# Libraries ---------------------------------------------------------------

library(readxl) # read excel
library(minpack.lm)   # nlsLM for optimization
library(tidyverse) # data clean

# Load data ---------------------------------------------------------------

data <- read_excel("data/data-swrc.xlsx") %>%
  rename(pF = `pF [-]`, VWC = `Water Content [Vol%]`) %>%
  filter(!is.na(pF), !is.na(VWC))

# Van Genuchten -----------------------------------------------------------

# θ(h) = θ_r + (θ_s - θ_r) / [1 + (α·h)^n]^(1 - 1/n)
#
# where h = 10^pF  (matric potential in cm H₂O) 
#
# Parameters:
#   θ_s  — saturated water content (%)
#   θ_r  — residual water content  (%)
#   α    — scale parameter related to air-entry pressure (cm⁻¹)
#   n    — shape parameter (dimensionless, > 1)

source("R/parameter-estimation.R") # from h to pF

data_fitted <- fit_unimodal_vg(data)

data_fitted$params #parameters ready!

# FC - PWP - PAW ----------------------------------------------------------

# Field Capacity (FC)        → pF = 2.5  (h ≈ 316 cm ≈ −0.03 MPa)
# Permanent Wilting Point (PWP) → pF = 4.2  (h ≈ 15 849 cm ≈ −1.5 MPa)
# Plant Available Water (PAW)   = θ_FC − θ_PWP

source("R/hydraulic-properties.R") # see function

vg_params <- data_fitted$params

hydraulics <- calculate_hydraulic(
  theta_s = vg_params["theta_s"],
  theta_r = vg_params["theta_r"],
  alpha      = vg_params["alpha"],
  n          = vg_params["n"]
)

# Dataset -----------------------------------------------------------------

pF_seq  <- seq(min(data$pF), max(data$pF), length.out = 500)
h_seq   <- 10^pF_seq
theta_s <- vg_params["theta_s"]
theta_r <- vg_params["theta_r"]
alpha   <- vg_params["alpha"]
n_par   <- vg_params["n"]

# Fitted curve ------------------------------------------------------------

fitted_curve <- data.frame(
  pF  = pF_seq,
  VWC = theta_r + (theta_s - theta_r) / (1 + (alpha * h_seq)^n_par)^(1 - 1/n_par)
)

# ggplot ------------------------------------------------------------------

pF_fc  <- 2.5 # references
pF_pwp <- 4.2 # references
vwc_fc  <- hydraulics$theta_fc
vwc_pwp <- hydraulics$theta_pwp

# Labels for plot ---------------------------------------------------------

label_df <- data.frame(
  pF    = c(pF_fc  + 0.08, pF_pwp + 0.08),
  VWC   = c(vwc_fc  + 1.5,  vwc_pwp + 1.5),
  label = c(
    sprintf("FC\npF 2.5\nθ = %.1f%%", vwc_fc),
    sprintf("PWP\npF 4.2\nθ = %.1f%%", vwc_pwp)
  )
)

# Labels ------------------------------------------------------------------

plot_swrc <- ggplot() +
  # Observed data
  geom_point(data = data, aes(x = pF, y = VWC),
             shape = 21, fill = "#5B8DB8", colour = "white",
             size = 2.2, alpha = 0.75) +
  # Fitted van Genuchten curve
  geom_line(data = fitted_curve, aes(x = pF, y = VWC),
            colour = "#1A3A5C", linewidth = 1.1) +
  # FC vertical + horizontal reference lines
  geom_vline(xintercept = pF_fc,  linetype = "dashed",
             colour = "#2E8B57", linewidth = 0.8) +
  geom_hline(yintercept = vwc_fc, linetype = "dashed",
             colour = "#2E8B57", linewidth = 0.8) +
  # PWP vertical + horizontal reference lines
  geom_vline(xintercept = pF_pwp, linetype = "dashed",
             colour = "#C0392B", linewidth = 0.8) +
  geom_hline(yintercept = vwc_pwp, linetype = "dashed",
             colour = "#C0392B", linewidth = 0.8) +
  # FC annotation point
  geom_point(aes(x = pF_fc, y = vwc_fc),
             shape = 23, fill = "#2E8B57", colour = "white",
             size = 4) +
  # PWP annotation point
  geom_point(aes(x = pF_pwp, y = vwc_pwp),
             shape = 23, fill = "#C0392B", colour = "white",
             size = 4) +
  # Text labels
  geom_text(data = label_df, aes(x = pF, y = VWC, label = label),
            size = 3.2, lineheight = 0.9, hjust = 0, colour = "grey20") +
  # PAW shaded area using a ribbon along the fitted curve
  geom_ribbon(
    data = fitted_curve %>% filter(pF >= pF_fc, pF <= pF_pwp),
    aes(x = pF, ymin = vwc_pwp, ymax = VWC),
    fill = "#A8D5BA", alpha = 0.35
  ) +
  annotate("text",
           x     = (pF_fc + pF_pwp) / 2,
           y     = (vwc_fc + vwc_pwp) / 2,
           label = sprintf("PAW\n%.1f%%", hydraulics$paw),
           size  = 3.5, colour = "#1A6B3A", fontface = "bold") +
  scale_x_continuous(breaks = seq(0, 7, 1)) +
  scale_y_continuous(limits = c(0, 52), breaks = seq(0, 50, 10)) +
  labs(
    title    = "Soil Water Retention Curve — van Genuchten Model",
    subtitle = "Field Capacity (FC), Permanent Wilting Point (PWP) and Plant Available Water (PAW)",
    x        = "pF",
    y        = "Volumetric Water Content (%)"
  ) +
  theme_bw(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(colour = "grey40", size = 10),
    panel.grid.minor = element_blank()
  )

# Save PNG
ggsave("plots/swrc_unimodal_vg.png", plot = plot_swrc,
       width = 10, height = 6.5, dpi = 150)

