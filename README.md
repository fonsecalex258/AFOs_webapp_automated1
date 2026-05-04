# Living Systematic Review Platform: AFO Health Outcomes

📖 Overview

This repository implements a reproducible system for a living systematic review (LSR) investigating health outcomes associated with residential exposure to animal feeding operations (AFOs).

The platform is designed as a two-layer architecture:

Extraction layer → structured evidence identification, screening, and data extraction using DistillerSR
Application layer → interactive exploration and visualization using Shiny

This separation enables controlled updates, reproducible datasets, and stable dissemination of results.

Unlike traditional systematic reviews or static LSR outputs, this system supports interactive interrogation of heterogeneous observational evidence, allowing users to explore exposure–outcome relationships across study designs and contexts without requiring data aggregation.


🌐 Live Application

👉 https://livestock-lsr.shinyapps.io/LivingSR/

🔄 Living Systematic Review Workflow

Search and updates

Standardized PubMed search syntax implemented in DistillerSR
Reviewers manually trigger “rerun search” every 3–6 months
Newly identified studies are incorporated into the review database

Screening

Two-stage screening (title/abstract + full text)
AI-assisted prioritization using relevance scoring (threshold = 0.2)
Final inclusion decisions confirmed by human reviewers

Data extraction

Structured extraction of:
Study characteristics
Exposure definitions
Health outcomes
Effect estimates
Risk-of-bias assessments

🧱 Data Pipeline and Cache System

Processed datasets are standardized and stored as .rds files, forming a version-controlled cache layer.

Key cache files
included_cache_1.rds → core study metadata
cross_base_cache.rds → cross-sectional data
forest_case_cache.rds → case-control data
forest_cohort_cache.rds → cohort data
refs_cache.rds → PRISMA counts

Purpose

Ensure consistent structure across updates
Enable fast loading and stable outputs
Eliminate dependence on external APIs


📊 Application Features 

The Shiny application operationalizes the analytical framework through:

📈 Forest plots (interactive, study-level)
🌍 Geographic mapping of studies
⏱ Temporal trends of evidence accumulation
🔄 PRISMA flow diagram (data-driven)
📋 Interactive tables (included/excluded studies)
⚖️ Risk-of-bias summaries

All outputs are dynamically generated from the same underlying dataset.



Use cases

Researchers exploring exposure–outcome relationships
Policymakers and stakeholders assessing public health risks
Evidence synthesis teams identifying gaps and patterns in the literature
