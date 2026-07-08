# 📈 Stock Portfolio Analysis using Python, SQL & Power BI

## 📌 Project Overview

This project analyzes a diversified stock portfolio using **Python**, **SQL**, and **Power BI**. It demonstrates a complete end-to-end data analytics workflow, from collecting stock market data to building interactive dashboards for portfolio performance analysis.

The project includes:

- Automated stock data collection using Yahoo Finance API
- Data cleaning and feature engineering using Python
- SQL-based portfolio analysis
- Interactive Power BI dashboards
- Financial performance and risk analysis

---

# 🎯 Objectives

- Analyze portfolio allocation across sectors and companies
- Measure portfolio profitability and returns
- Track portfolio value over time
- Identify top-performing investments
- Perform drawdown and rolling average analysis
- Build interactive dashboards for decision-making

---

# 🛠️ Tech Stack

| Tool | Purpose |
|------|----------|
| Python | Data Collection & Preprocessing |
| Pandas | Data Manipulation |
| NumPy | Numerical Calculations |
| yFinance | Historical Stock Data |
| MySQL | Portfolio Analysis |
| Power BI | Dashboard & Visualization |

---

# 📂 Project Structure

```
Stock-Portfolio-Analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   ├── 01_Data_Collection_and_Preprocessing.py
│   └── 02_Feature_Engineering_and_Portfolio_Creation.py
│
├── sql/
│   ├── 01_Portfolio_Overview.sql
│   ├── 02_Portfolio_Performance.sql
│   ├── 03_Time_Series_Analysis.sql
│   └── 04_Stock_Performance.sql
│
├── powerbi/
│   └── Stock Portfolio Analysis.pbix
│
├── dashboards/
│   ├── Dashboard_1.png
│   ├── Dashboard_2.png
│   └── Dashboard_3.png
│
└── README.md
```

---

# 📊 Dataset

Historical stock market data was collected using the **Yahoo Finance API** for the following companies:

- Apple (AAPL)
- Microsoft (MSFT)
- NVIDIA (NVDA)
- Amazon (AMZN)
- Alphabet (GOOGL)
- JPMorgan Chase (JPM)
- Berkshire Hathaway (BRK-B)
- Tesla (TSLA)

### Data Period

**January 2021 – December 2025**

---

# ⚙️ Data Processing Workflow

### 1. Data Collection

- Download historical stock prices
- Store raw data
- Organize company and sector information

### 2. Data Quality Assessment

- Missing value check
- Duplicate detection
- Negative value validation
- Dataset statistics
- Date range verification

### 3. Data Cleaning

- Remove duplicate records
- Sort data by ticker and date
- Export cleaned dataset

### 4. Feature Engineering

Generated financial indicators including:

- Daily Return
- 20-Day Moving Average (MA20)
- 50-Day Moving Average (MA50)
- 20-Day Rolling Volatility
- Year
- Quarter
- Month
- Month Name

### 5. Portfolio Creation

Created a hypothetical investment portfolio with:

- ₹1,000,000 total investment
- Eight large-cap US companies
- Fixed allocation percentages
- Purchase date: 4 January 2021

---

# 🗄️ SQL Analysis

The project includes SQL analysis covering:

### Portfolio Overview

- Total Investment
- Average Investment
- Sector Allocation
- Company Distribution

### Portfolio Performance

- Current Portfolio Value
- Profit/Loss
- Return Percentage
- Company Ranking
- Sector-wise Returns

### Time Series Analysis

- Daily Portfolio Value
- Daily Change
- Daily Returns
- Rolling 30-Day Average

### Risk Analysis

- Maximum Drawdown
- Drawdown Percentage
- Profit Contribution by Stock

---

# 📈 Power BI Dashboards

## Dashboard 1 – Portfolio Overview

- Total Investment
- Number of Holdings
- Investment Allocation by Company
- Investment Allocation by Sector

---

## Dashboard 2 – Portfolio Performance

- Current Portfolio Value
- Total Profit
- Portfolio Return
- Company-wise Profit
- Sector-wise Returns
- Investment vs Current Value

---

## Dashboard 3 – Stock Performance Analysis

- Historical Price Trend
- Moving Average Analysis
- Trading Volume
- 52-Week High & Low
- Stock Performance Metrics

---

# 📌 Key Features

- End-to-end analytics workflow
- Automated data collection
- SQL window functions
- Common Table Expressions (CTEs)
- Financial performance analysis
- Risk analysis using drawdown
- Rolling average calculations
- Interactive Power BI dashboards

---

# 🚀 Skills Demonstrated

### Python

- Pandas
- Data Cleaning
- Feature Engineering
- Financial Calculations
- File Handling

### SQL

- Joins
- Aggregate Functions
- CTEs
- Window Functions
- Ranking Functions
- LAG()
- Rolling Calculations

### Power BI

- Data Modeling
- DAX Measures
- Interactive Dashboards
- KPI Cards
- Conditional Formatting
- Slicers

---

# 📷 Dashboard Preview

## Dashboard 1 – Portfolio Overview

![Dashboard 1](dashboards/Dashboard1.png)

---

## Dashboard 2 – Portfolio Performance

![Dashboard 2](dashboards/Dashboard2.png)

---

## Dashboard 3 – Stock Performance Analysis

![Dashboard 3](dashboards/Dashboard3.png)

---

## Project Highlights

- Automated stock data collection using Python.
- Performed data cleaning and feature engineering.
- Created reusable SQL scripts for portfolio analysis.
- Built interactive Power BI dashboards.
- Applied DAX measures and window functions for financial analytics.

---

# 👩‍💻 Author

**Puneet Kaur**

B.Tech – Production & Industrial Engineering
