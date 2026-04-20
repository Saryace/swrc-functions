# swrc-functions

**Soil Water Retention Curve (SWRC) fitting using the unimodal van Genuchten model**  
**Ajuste de la Curva de Retención de Agua en Suelo (SWRC) usando el modelo unimodal de van Genuchten**

---

## English

### Overview

This repository provides functions in **R** and **Python** to fit the **unimodal van Genuchten (VG) model** to soil water retention curve data, derive key hydraulic properties, and produce publication-ready plots.

### The van Genuchten Equation

$$\theta(h) = \theta_r + \frac{\theta_s - \theta_r}{\left[1 + (\alpha \, h)^n\right]^{1-1/n}}$$

| Parameter | Description | Units |
|-----------|-------------|-------|
| θ_s | Saturated water content | % |
| θ_r | Residual water content | % |
| α | Scale parameter (air-entry related) | cm⁻¹ |
| n | Shape parameter | dimensionless |
| h | Matric potential = 10^pF | cm H₂O |

### Hydraulic properties calculated

| Property | pF threshold | Matric potential |
|----------|-------------|-----------------|
| Field Capacity (FC) | 2.5 | −0.03 MPa |
| Permanent Wilting Point (PWP) | 4.2 | −1.5 MPa |
| Plant Available Water (PAW) | — | θ_FC − θ_PWP |

### Repository structure

```
swrc-functions/
├── data/
│   └── data-swrc.xlsx        # Example SWRC dataset (pF, VWC %)
├── R/
│   └── van_genuchten_swrc.R  # R script (minpack.lm / nlsLM)
└── python/
    └── van_genuchten_swrc.ipynb  # Jupyter notebook (scipy)
```

### Key functions

**`fit_unimodal_vg(data)`** — fits the VG model using nonlinear least squares, returns parameters (θ_s, θ_r, α, n), R², RMSE and AIC.

**`calculate_hydraulic(theta_s, theta_r, alpha, n)`** — computes FC, PWP and PAW from the fitted parameters.

### Output plot

![SWRC van Genuchten](plots/swrc_unimodal_vg.png)

### Usage

**R** — requires `readxl`, `minpack.lm`, `dplyr`, `ggplot2`
```r
source("R/van_genuchten_swrc.R")
```

**Python** — requires `numpy`, `pandas`, `scipy`, `matplotlib`, `openpyxl`

Open the notebook directly in Google Colab:

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://githubtocolab.com/Saryace/swrc-functions/blob/main/python/van_genuchten_swrc.ipynb)

> Tip: to open any notebook from this repo in Colab, change the domain in the URL from `github.com` to `githubtocolab.com`.

---

## Español

### Descripción

Este repositorio contiene funciones en **R** y **Python** para ajustar el **modelo unimodal de van Genuchten (VG)** a datos de la curva de retención de agua en suelo (SWRC), calcular propiedades hidráulicas clave y generar gráficos listos para publicación.

### Ecuación de van Genuchten

$$\theta(h) = \theta_r + \frac{\theta_s - \theta_r}{\left[1 + (\alpha \, h)^n\right]^{1-1/n}}$$

| Parámetro | Descripción | Unidades |
|-----------|-------------|----------|
| θ_s | Contenido de agua saturado | % |
| θ_r | Contenido de agua residual | % |
| α | Parámetro de escala (relacionado con la presión de entrada de aire) | cm⁻¹ |
| n | Parámetro de forma | adimensional |
| h | Potencial mátrico = 10^pF | cm H₂O |

### Propiedades hidráulicas calculadas

| Propiedad | Umbral pF | Potencial mátrico |
|-----------|-----------|-------------------|
| Capacidad de campo (CC) | 2.5 | −0.03 MPa |
| Punto de marchitez permanente (PMP) | 4.2 | −1.5 MPa |
| Agua disponible para plantas (ADP) | — | θ_CC − θ_PMP |

### Estructura del repositorio

```
swrc-functions/
├── data/
│   └── data-swrc.xlsx        # Datos de ejemplo (pF, VWC %)
├── R/
│   └── van_genuchten_swrc.R  # Script R (minpack.lm / nlsLM)
└── python/
    └── van_genuchten_swrc.ipynb  # Notebook Jupyter (scipy)
```

### Funciones principales

**`fit_unimodal_vg(data)`** — ajusta el modelo VG mediante mínimos cuadrados no lineales; retorna los parámetros (θ_s, θ_r, α, n), R², RMSE y AIC.

**`calculate_hydraulic(theta_s, theta_r, alpha, n)`** — calcula CC, PMP y ADP a partir de los parámetros ajustados.

### Gráfico de salida

![SWRC modelo van Genuchten](plots/swrc_unimodal_vg.png)

### Uso

**R** — requiere `readxl`, `minpack.lm`, `dplyr`, `ggplot2`
```r
source("R/van_genuchten_swrc.R")
```

**Python** — requiere `numpy`, `pandas`, `scipy`, `matplotlib`, `openpyxl`

Abre el notebook directamente en Google Colab:

[![Abrir en Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://githubtocolab.com/Saryace/swrc-functions/blob/main/python/van_genuchten_swrc.ipynb)

> tip: para abrir cualquier notebook de este repositorio en Colab, cambia el dominio de la URL de `github.com` a `githubtocolab.com`.
