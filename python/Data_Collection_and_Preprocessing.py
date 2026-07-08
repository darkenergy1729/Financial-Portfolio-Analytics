"""
===========================================================
Stock Portfolio Analysis
===========================================================

Author  : Puneet Kaur
Project : Stock Portfolio Analysis using Python, SQL & Power BI

Description:
------------
This script performs the following tasks:

1. Downloads historical stock market data from Yahoo Finance
2. Performs data quality assessment
3. Cleans the dataset
4. Saves the processed datasets for further analysis

Input:
    None (Downloads data directly from Yahoo Finance)

Output:
    data/raw/raw_stock_data.csv
    data/processed/stock_data_clean.csv
===========================================================
"""

# =========================================================
# Import Libraries
# =========================================================

import pandas as pd
import yfinance as yf
from pathlib import Path

# =========================================================
# Create Project Folders
# =========================================================

RAW_PATH = Path("data/raw")
PROCESSED_PATH = Path("data/processed")

RAW_PATH.mkdir(parents=True, exist_ok=True)
PROCESSED_PATH.mkdir(parents=True, exist_ok=True)

# =========================================================
# Portfolio Stocks
# =========================================================

STOCKS = {
    "AAPL": {"Company": "Apple", "Sector": "Technology"},
    "MSFT": {"Company": "Microsoft", "Sector": "Technology"},
    "NVDA": {"Company": "NVIDIA", "Sector": "Technology"},
    "AMZN": {"Company": "Amazon", "Sector": "Consumer Discretionary"},
    "GOOGL": {"Company": "Alphabet", "Sector": "Communication Services"},
    "JPM": {"Company": "JPMorgan Chase", "Sector": "Financials"},
    "BRK-B": {"Company": "Berkshire Hathaway", "Sector": "Financials"},
    "TSLA": {"Company": "Tesla", "Sector": "Consumer Discretionary"},
}

START_DATE = "2021-01-01"
END_DATE = "2026-01-01"

# =========================================================
# Download Historical Stock Data
# =========================================================

stock_frames = []

for ticker, info in STOCKS.items():

    stock_df = yf.download(
        ticker,
        start=START_DATE,
        end=END_DATE,
        progress=False,
        auto_adjust=False,
        group_by="column",
    )

    # Flatten MultiIndex columns if present
    if isinstance(stock_df.columns, pd.MultiIndex):
        stock_df.columns = stock_df.columns.get_level_values(0)

    stock_df.reset_index(inplace=True)

    stock_df["Ticker"] = ticker
    stock_df["Company"] = info["Company"]
    stock_df["Sector"] = info["Sector"]

    stock_frames.append(stock_df)

# =========================================================
# Combine All Stock Data
# =========================================================

stock_data = pd.concat(stock_frames, ignore_index=True)

stock_data = stock_data[
    [
        "Date",
        "Ticker",
        "Company",
        "Sector",
        "Open",
        "High",
        "Low",
        "Close",
        "Adj Close",
        "Volume",
    ]
]

# =========================================================
# Save Raw Dataset
# =========================================================

stock_data.to_csv(
    RAW_PATH / "raw_stock_data.csv",
    index=False,
)

# =========================================================
# Data Quality Assessment
# =========================================================

# Dataset Information
stock_data.info()

# Missing Values
stock_data.isnull().sum()

# Duplicate Records
stock_data.duplicated().sum()

# Summary Statistics
stock_data.describe()

# Date Range
stock_data["Date"].min()
stock_data["Date"].max()

# Records per Stock
stock_data.groupby("Ticker").size()

# Check for Negative Prices
(
    stock_data[
        ["Open", "High", "Low", "Close", "Adj Close"]
    ] <= 0
).sum()

# Check for Negative Volume
(stock_data["Volume"] < 0).sum()

# =========================================================
# Data Cleaning
# =========================================================

clean_data = stock_data.copy()

# Remove duplicate rows
clean_data.drop_duplicates(inplace=True)

# Sort by Ticker and Date
clean_data.sort_values(
    by=["Ticker", "Date"],
    inplace=True,
)

# Reset Index
clean_data.reset_index(
    drop=True,
    inplace=True,
)

# =========================================================
# Save Clean Dataset
# =========================================================

clean_data.to_csv(
    PROCESSED_PATH / "stock_data_clean.csv",
    index=False,
)

print("Data collection and preprocessing completed successfully.")
