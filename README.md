# MercadoLibre Funnel & Retention Analysis

## Project Overview
This project analyzes the user conversion funnel and retention behavior for a fictional MercadoLibre dataset.
The analysis covers the period from January 1, 2025 to August 31, 2025.

The goal is to identify:
- Where users drop off in the conversion funnel
- How retention evolves over time
- Differences across countries and cohorts
- Actionable opportunities to improve growth and retention

## Business Context
As a Product Analyst within the Growth & Retention team, the objective was to understand:
- Which funnel stages generate the highest user loss
- How retention behaves across countries and monthly cohorts

## Key Findings
- The largest drop-off occurs between **product selection and add-to-cart**, where ~65% of users are lost.
- Final purchase conversion is low (~1.25%), indicating high friction late in the funnel.
- Uruguay shows the highest final conversion rate, while Colombia and Ecuador underperform.
- Retention declines sharply after Day 14 across all countries.
- August 2025 cohort shows critically low retention (D28 ≈ 0.2%).

## Business Implications
- Prioritize optimization of the **add-to-cart step** (UX, pricing clarity, trust signals).
- Implement **early retention strategies** within the first 14 days (onboarding, reminders).
- Launch **country-specific reactivation campaigns**, especially for low-performing regions.
- Focus on improving perceived product value early in the user journey.

## Personal Reflection
- The first stage to improve would be the transition from product selection to add-to-cart due to its high impact on revenue.
- Users show strong initial interest but low purchase intent, suggesting friction rather than lack of demand.
- Retention behavior highlights the importance of early engagement and value communication.

## Files
- `01_data_exploration.sql` – Schema exploration and event validation
- `02_funnel_conversion.sql` – Funnel construction and conversion analysis
- `03_retention_cohorts.sql` – Retention analysis by country and cohort
