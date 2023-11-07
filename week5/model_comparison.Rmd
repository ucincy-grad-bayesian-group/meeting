---
layout: page
title: Model Comparison Criterions
permalink: /about/
---

**1. Difference between model checking and model comparison**

**2. Model comparison in terms of predictive fit**

-   Point prediction.

    -   Mean squared error. $$\frac{1}{n}\sum_{i=1}^n (y_i-E(y_i\mid \theta))^2$$
        -   less appropriate for models far from normal

-   Probabilistic prediction.

    -   proper and local scoring rule -\> logarithmic score
        -   log predictive density(lpd) or log-likelihood $log(p(y\mid \theta))$

-   Predictive accuracy for a single data point $\tilde{y}_i$ $$
    \log p_{\text {post }}\left(\tilde{y}_i\right)=\log \mathrm{E}_{\text {post }}\left(p\left(\tilde{y}_i \mid \theta\right)\right)=\log \int p\left(\tilde{y}_i \mid \theta\right) p_{\text {post }}(\theta) d \theta
    $$

    -   Averaging over distribution of $\tilde{y}_i$ $$
        \begin{aligned}
        \text { elpd } & =\text { expected } \log \text { predictive density for a new data point } \\
        & =\mathrm{E}_f\left(\log p_{\text {post }}\left(\tilde{y}_i\right)\right)=\int\left(\log p_{\text {post }}\left(\tilde{y}_i\right)\right) f\left(\tilde{y}_i\right) d \tilde{y}
        \end{aligned}
        $$

    -   For a future dataset of size n $$
        \begin{aligned}
        \text { elppd } & =\text { expected } \log \text { pointwise predictive density for a new dataset } \\
        & =\sum_{i=1}^n \mathrm{E}_f\left(\log p_{\text {post }}\left(\tilde{y}_i\right)\right)
        \end{aligned}
        $$

    -   In practice we don't know $f\left(\tilde{y}_i\right)$, what we have is the data at hand

**Solutions to approximate** $f$:

-   Within-sample predictive accuracy

    $$
        \begin{aligned}
        \text { lppd } & =\log \text { pointwise predictive density } \\
        & =\log \prod_{i=1}^n p_{\text {post }}\left(y_i\right)=\sum_{i=1}^n \log \int p\left(y_i \mid \theta\right) p_{\text {post }}(\theta) d \theta
        \end{aligned}
        $$

    -   Monte Carlo Integration: $$
        \begin{aligned}
        \text { computed lppd } & =\text { computed log pointwise predictive density } \\
        & =\sum_{i=1}^n \log \left(\frac{1}{S} \sum_{s=1}^S p\left(y_i \mid \theta^s\right)\right)
        \end{aligned}
         $$
    -   lppd overestimates elppd

-   Adjusted within-sample predictive accuracy.

    -   AIC, DIC, WAIC

-   Cross-validation

    -   LOOIC

**Information Criteria**

-   Akaike information criterion (AIC) $$ \widehat{\operatorname{elpd}}_{\mathrm{AIC}}=\log p\left(y \mid \hat{\theta}_{\mathrm{mle}}\right)-k
    $$
    -   $k$: number of parameters. $$\mathrm{AIC}=-2 \log p\left(y \mid \hat{\theta}_{\text {mle }}\right)+2 k$$

    -   Why not appropriate for bayesian methods?
-   Deviance information criterion (DIC)

$$\widehat{\operatorname{elpd}}_{\text {DIC }}=\log p\left(y \mid \hat{\theta}_{\text {Bayes }}\right)-p_{\text {DIC }}$$

$$p_{\text {DIC }}=2\left(\log p\left(y \mid \hat{\theta}_{\text {Bayes }}\right)-\mathrm{E}_{\text {post }}(\log p(y \mid \theta))\right)$$

$$
\text { computed } p_{\text {DIC }}=2\left(\log p\left(y \mid \hat{\theta}_{\text {Bayes }}\right)-\frac{1}{S} \sum_{s=1}^S \log p\left(y \mid \theta^s\right)\right)
$$

-   Why the degrees of freedom is calculated this way?
    -   the distance between the log maximum likelihood and the posterior mean of the log-likelihood

$$
\mathrm{DIC}=-2 \log p\left(y \mid \hat{\theta}_{\text {Bayes }}\right)+2 p_{\text {DIC }}
$$

-   Watanabe-Akaike or widely applicable information criterion (WAIC)

$$
\widehat{\text { elppd }}_{\text {WAIC }}=\operatorname{lppd}-p_{\text {WAIC }}
$$ $$
        \begin{aligned}
        \text { computed lppd } & =\text { computed log pointwise predictive density } \\
        & =\sum_{i=1}^n \log \left(\frac{1}{S} \sum_{s=1}^S p\left(y_i \mid \theta^s\right)\right)
        \end{aligned}
         $$

$$
\text { computed } p_{\mathrm{WAIC} 1}=2 \sum_{i=1}^n\left(\log \left(\frac{1}{S} \sum_{s=1}^S p\left(y_i \mid \theta^s\right)\right)-\frac{1}{S} \sum_{s=1}^S \log p\left(y_i \mid \theta^s\right)\right)
$$

$$
WAIC = -2lppd + 2p_{\text {WAIC }}
$$

**Effective number of parameters Comparison:**

-   AIC: k
-   DIC: $$
    \text { computed } p_{\text {DIC }}=2\left(\log p\left(y \mid \hat{\theta}_{\text {Bayes }}\right)-\frac{1}{S} \sum_{s=1}^S \log p\left(y \mid \theta^s\right)\right)
    $$
-   WAIC:

$$
\text { computed } p_{\mathrm{WAIC} 1}=2 \sum_{i=1}^n\left(\log \left(\frac{1}{S} \sum_{s=1}^S p\left(y_i \mid \theta^s\right)\right)-\frac{1}{S} \sum_{s=1}^S \log p\left(y_i \mid \theta^s\right)\right)
$$

Equivalent under normal linear model with known variance and flat prior.

**Leave-one-out cross-validation**

$$
\operatorname{lppd}_{\mathrm{loo}-\mathrm{cv}}=\sum_{i=1}^n \log p_{\mathrm{post}(-i)}\left(y_i\right) \text {, calculated as } \sum_{i=1}^n \log \left(\frac{1}{S} \sum_{s=1}^S p\left(y_i \mid \theta^{i s}\right)\right)
$$

$$
p_{loo-cv} = lppd - lppd_{loo-cv}\\
lppd_{loo-cv} = lppd- p_{loo-cv}
$$

$$
LOOIC = -2lppd_{loo-cv}
$$

-   It is computationally expensive. In Rstan, they use PSIS-LOO.

**Relationship:**

1.  AIC asymptotically equal to LOO-CV using MLE

2.  DIC asymptotically equal to LOO-CV plug-in predictive densities

3.  WAIC asymptotically equal to Bayesian LOO-CV
