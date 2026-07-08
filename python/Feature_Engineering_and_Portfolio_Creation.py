"""
===========================================================
Stock Portfolio Analysis
===========================================================

Author  : Puneet Kaur
Project : Stock Portfolio Analysis using Python, SQL & Power BI

Description:
------------
This script performs the following tasks:

1. Creates technical indicators
   - Daily Return
   - 20-Day Moving Average
   - 50-Day Moving Average
   - 20-Day Rolling Volatility
   - Calendar Features

2. Creates a sample investment portfolio

Input:
    data/processed/stock_data_clean.csv

Output:
    data/processed/stock_data_features.csv
    data/processed/portfolio_holdings.csv
===========================================================
"""

# =========================================================
# Import Libraries
# =========================================================

import pandas as pd
from pathlib import Path

# =========================================================
# File Paths
# =========================================================

PROCESSED_PATH = Path("data/processed")

# =========================================================
# Load Clean Dataset
# =========================================================

stock_data = pd.read_csv(
    PROCESSED_PATH / "stock_data_clean.csv",
    parse_dates=["Date"]
)

# =========================================================
# Feature Engineering
# =========================================================

# Daily Return
stock_data["Daily Return"] = (
    stock_data.groupby("Ticker")["Adj Close"]
    .pct_change()
)

# 20-Day Moving Average
stock_data["MA_20"] = (
    stock_data.groupby("Ticker")["Adj Close"]
    .transform(lambda x: x.rolling(20).mean())
)

# 50-Day Moving Average
stock_data["MA_50"] = (
    stock_data.groupby("Ticker")["Adj Close"]
    .transform(lambda x: x.rolling(50).mean())
)

# 20-Day Rolling Volatility
stock_data["Volatility_20"] = (
    stock_data.groupby("Ticker")["Daily Return"]
    .transform(lambda x: x.rolling(20).std())
)

# =========================================================
# Calendar Features
# =========================================================

stock_data["Year"] = stock_data["Date"].dt.year
stock_data["Quarter"] = stock_data["Date"].dt.quarter
stock_data["Month"] = stock_data["Date"].dt.month
stock_data["Month Name"] = stock_data["Date"].dt.month_name()

# =========================================================
# Save Feature Engineered Dataset
# =========================================================

stock_data.to_csv(
    PROCESSED_PATH / "stock_data_features.csv",
    index=False
)

# =========================================================
# Portfolio Creation
# =========================================================

TOTAL_INVESTMENT = 1_000_000

PURCHASE_DATE = pd.Timestamp("2021-01-04")

PORTFOLIO_ALLOCATION = {
    "AAPL": 20,
    "MSFT": 15,
    "NVDA": 15,
    "AMZN": 10,
    "GOOGL": 10,
    "JPM": 10,
    "BRK-B": 10,
    "TSLA": 10,
}

# =========================================================
# Load Purchase Prices
# =========================================================

purchase_prices = stock_data[
    stock_data["Date"] == PURCHASE_DATE
].copy()

purchase_prices = purchase_prices[
    [
        "Ticker",
        "Company",
        "Sector",
        "Adj Close"
    ]
]

purchase_prices.rename(
    columns={"Adj Close": "Purchase Price"},
    inplace=True
)

# =========================================================
# Portfolio Allocation
# =========================================================

purchase_prices["Allocation (%)"] = (
    purchase_prices["Ticker"]
    .map(PORTFOLIO_ALLOCATION)
)

purchase_prices["Investment Amount"] = (
    purchase_prices["Allocation (%)"] / 100
) * TOTAL_INVESTMENT

# =========================================================
# Calculate Shares Purchased
# =========================================================

purchase_prices["Shares Purchased"] = (
    purchase_prices["Investment Amount"]
    / purchase_prices["Purchase Price"]
)

# =========================================================
# Format Numeric Columns
# =========================================================

purchase_prices["Purchase Price"] = (
    purchase_prices["Purchase Price"].round(2)
)

purchase_prices["Investment Amount"] = (
    purchase_prices["Investment Amount"].round(2)
)

purchase_prices["Shares Purchased"] = (
    purchase_prices["Shares Purchased"].round(4)
)

# =========================================================
# Create Portfolio Holdings
# =========================================================

portfolio_holdings = purchase_prices[
    [
        "Ticker",
        "Company",
        "Sector",
        "Allocation (%)",
        "Investment Amount",
        "Purchase Price",
        "Shares Purchased"
    ]
]

portfolio_holdings.reset_index(
    drop=True,
    inplace=True
)

# =========================================================
# Save Portfolio Holdings
# =========================================================

portfolio_holdings.to_csv(
    PROCESSED_PATH / "portfolio_holdings.csv",
    index=False
)
