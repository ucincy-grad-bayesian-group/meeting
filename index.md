---
layout: default
title: UCincy Grad Bayesian Analysis Group
---

# Welcome to the UCincy Grad Bayesian Analysis Group

## About Us
We are a group of graduate statistics students at the University of Cincinnati with a strong focus on applying Bayesian statistics to real, intricate data. Our weekly meetings include discussions on both textbooks and practical data analysis, allowing us to explore advanced topics in Bayesian statistics.

## Meetings

Our meetings take place every Friday at 4:00 PM French Hall 4119. For those who cannot attend in person, you are welcome to join us online via Zoom using the link: [Link](https://ucincinnati.zoom.us/j/6617187079).

## This Week's Topic

**Apr 5th:** A hierarchial model for clinical trial [Kyle Mann].
  
## Meeting Schedule and Topics

In our series of meetings, we will cover several key stages of modeling techniques and applications. Below is the general schedule and the main topics to be discussed in each stage:

### Stage 1: Basic Modeling Technique
This stage will lay the foundation for our modeling approach, focusing on:

- **Prior Setup:** Establishing initial assumptions and baselines for our models.
- **Common Probability Models:** Exploring various probability models and their applications.
- **Model Checking and Comparison:** Techniques for validating and comparing different models.
  
These techniques will be a recurring theme and will be applied throughout our subsequent discussions.

### Stage 2: Hierarchical Model
In the second stage, we will delve into Hierarchical Models, exploring their structure, benefits, and specific use cases in complex data analysis.

### Stage 3: Models Taking into Account Data Collection Process
This stage will focus on models that specifically consider the data collection process, ensuring that our analysis accounts for any biases or limitations inherent in how the data was gathered.



## Recent Discussions

- **Discussion 0:** Introduction. [Slide](/meeting/week0/Bayesian_Reading_Group_Intro.pdf)

- **Discussion 1:** "Modeling and Posterior Predictive Check for Football Data." This session, led by Yuan, focused on introducing the posterior predictive check as a comprehensive and adaptable method for evaluating Bayesian models. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week1/football_normal.Rmd). [Html](/meeting/week1/football_normal.html).

- **Discussion 2:** "Modeling for Airline Fatalities Data." Jiwon explored the use of the Poisson model to analyze airline fatalities data, considering both with and without passenger miles. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week2/BDAanalysis.Rmd). [Html](/meeting/week2/BDAanalysis.html).

- **Discussion 3:**  "Non-informative Prior." Kyle covered common non-informative priors, applying them to 2022 American birth data, and discussed their use in clinical trials, illustrating with examples. [Slide](/meeting/week3/UninformativePriorDistribution.pdf)

- **Discussion 4:**
  - Theory of Weakly Informative Prior." Hancheng discussed the concept and implications of weakly informative priors, applying them to airline fatalities data. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week4/poisson%20regression%20(Using%20Jiwon's%20data).Rmd). [Html](/meeting/week4/poisson-regression--Using-Jiwon-s-data-.html).
  - "Advantages of Using Weakly Informative Prior." Yuan demonstrated the benefits through two examples: estimating sex ratios to avoid absurd results and applying them in logistic regression with complete separation for more reasonable outcomes. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week4/sex_ratio_example.Rmd). [Html](/meeting/week4/sex_ratio_example.html).
      - "Frequentist Properties of Weakly Informative Prior in Sex Ratio Example." Kyle examined the effects of using a N(0,0.007) prior for the difference parameter in probability \(p_1-p_2\), showing its impact on statistical power. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week4/sex_ratio_example_km.Rmd). [pdf](/meeting/week4/SexRatios.pdf)

- **Discussion 5:**
  - "Theory of Model Comparison Criteria." Yuan delved into Bayesian model comparison criteria like DIC, WAIC, and LOOIC. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week5/model_comparison.Rmd). [Html](/meeting/week5/model_comparison.html)
  - "Application." Eric demonstrated how to calculate these criteria for Rstan models. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week5/Model_comp.Rmd). [html](/meeting/week5/Model_comp.html)

- **Discussion 6:** "Andrew Gelman's Analysis of Golf Putting Data." Rick presented Gelman's work on golf putting data, showcasing the flexibility of the Bayesian method and Rstan in building models from fundamental principles. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week6/BDA_12.13.2023.Rmd). [html](/meeting/week6/BDA_12.13.2023.html)

- **Discussion 7:** "Model Selection for Football Data." Hyogo conducted a comparative analysis of different models, evaluating their performance on test data specific to football. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week7/Oct-27-BDA-Contents.Rmd). [Html](/meeting/week7/Oct-27-BDA-Contents.html)

- **Discussion 8:**  "Model Checking for Logistic Regression Using School District Statement Data." Yuan introduced a method utilizing binned residuals for assessing Bayesian logistic regression models, applying this technique to analyze school district statement data. [R](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week8/school_statement_logistic.Rmd)

- **Discussion 9:** "Introduction to Bayesian Hierarchical Model". Kyle Mann talked about the concept and structure of Bayesian hierarchical modeling, and Bayesian information borrowing in clinical trials. [pdf](/meeting/week9/BayesianHierarchicalPresentation.pdf)

- **Discussion 10:** "A hierarchical model example from BDA- 8 school example". Yuan Zhou discussed the arguments the author proposed for using a hierarchical model in this example and the connection between it and James-Stein Estimator. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week10/8-school.Rmd). [Html](/meeting/week10/8-school.html)

- **Discussion 11 (Jan 19th):** "A hierarchical modeling for estimating team abilities in World Cup"- Kyle Mann.

- **Discussion 12 (Feb 2nd):** "A hierarchical modeling of the gym waiting time data"- Yuan Zhou. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week12/gym_analysis.Rmd). [Html](/meeting/week12/gym_analysis.html)

- **Discussion 13 (Feb 16th)** "How and why hierarchical model works"- Yuan Zhou. This discussion is about addressing some confusions regarding our gym data waiting model.[R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week15/multilevel.Rmd). [Html](/meeting/week15/multilevel.html)

- **Discussion 14 (Feb 23th):** "A hierarchical model for estimating excess mortality due to COVID19 in Bangladesh" - Hancheng Li. This model applies to a survey data and allows information sharing across month and age groups.[R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week14/Multilevel-JAMA.Rmd). [Html](/meeting/week14/Multilevel-JAMA.html)

- **Discussion 15 (Mar 1st):** "A hierarchical model for estimating species richness" - Yuan Zhou. This model accounts for species absence and nondetection. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week13/butterfly.Rmd). [Html](/meeting/week13/butterfly.html)

- **Discussion 16 (Mar 8th):** [Presidential Election Prediction Series 1] - Yuan Zhou. Yuan introduced a hierarchical model that allows information sharing across states and over time.  [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week16/election.Rmd). [Html](/meeting/week16/election.html)

- **Discussion 17 (Mar 22nd):** [Presidential Election Prediction Series 2] - Hancheng Li. Hancheng introduced a paper on presidential election prediction which combines prediction from time-for-change model and information from polls. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week17/Dynamic.Rmd). [Html](/meeting/week17/Dynamic.html)

- **Discussion 18 (Mar 29th):** [Presidential Election Prediction Series 3] - Yuan Zhou. Yuan introduced a model which is based on the model introduced in Series 2. It takes into account various sources of bias (house, population, polling mode effect) from the polls. [R Markdown](https://raw.githubusercontent.com/ucincy-grad-bayesian-group/meeting/main/week18/election_econ.Rmd). [Html](/meeting/week18/election_econ.html)

## Join Us
If you're a UC student interested in statistics and data science, we'd love to have you join us! Please [contact us](mailto:zhou3y4@mail.uc.edu) for more information.





