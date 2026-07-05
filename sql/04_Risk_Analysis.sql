/*
===============================================================================
Project      : Financial Portfolio Analytics
Author       : Puneet Kaur
Database     : MySQL

File         : 04_Risk_Analysis.sql

Description:
This script evaluates portfolio risk by analyzing profit contribution,
maximum drawdown, and overall portfolio profitability.

Business Questions Answered
---------------------------
1. Which stocks contributed the most to portfolio profit?
2. How much does each stock contribute to total profit?
3. What is the portfolio's maximum drawdown?
4. On which date did the portfolio experience its largest decline?

SQL Skills Demonstrated
-----------------------
• Common Table Expressions (CTEs)
• Window Functions (SUM OVER, MAX OVER)
• Financial Risk Analysis
• Portfolio Performance Analytics
===============================================================================
*/

USE financial_portfolio;



-- ============================================================================
-- Total Portfolio Profit
-- ============================================================================

SELECT

    ROUND(
        SUM(
            (h.`Shares Purchased` * f.`Adj Close`)
            - h.`Investment Amount`
        ),
        2
    ) AS Total_Portfolio_Profit

FROM portfolio_holdings h

JOIN stock_data_features f

ON h.Ticker = f.Ticker

WHERE f.Date =
(
    SELECT MAX(Date)
    FROM stock_data_features
);



-- ============================================================================
-- Profit Contribution by Stock
-- Shows how much each investment contributed to total portfolio profit
-- ============================================================================

WITH stock_profit AS
(
    SELECT

        h.Ticker,
        h.Company,

        ROUND(
            h.`Investment Amount`,
            2
        ) AS Investment,

        ROUND(
            h.`Shares Purchased` * f.`Adj Close`,
            2
        ) AS Current_Value,

        ROUND(
            (h.`Shares Purchased` * f.`Adj Close`)
            - h.`Investment Amount`,
            2
        ) AS Profit

    FROM portfolio_holdings h

    JOIN stock_data_features f

    ON h.Ticker = f.Ticker

    WHERE f.Date =
    (
        SELECT MAX(Date)
        FROM stock_data_features
    )
),

contribution AS
(
    SELECT

        *,

        SUM(Profit)
        OVER() AS Total_Profit

    FROM stock_profit
)

SELECT

    Ticker,
    Company,
    Investment,
    Current_Value,
    Profit,
    Total_Profit,

    ROUND(
        Profit / Total_Profit * 100,
        2
    ) AS Profit_Contribution_Percentage

FROM contribution

ORDER BY Profit_Contribution_Percentage DESC;



-- ============================================================================
-- Maximum Drawdown Analysis
-- Identifies the largest decline from a historical peak
-- ============================================================================

WITH portfolio_valuation AS
(
    SELECT

        f.Date,

        ROUND(
            SUM(
                h.`Shares Purchased`
                *
                f.`Adj Close`
            ),
            2
        ) AS Portfolio_Value

    FROM portfolio_holdings h

    JOIN stock_data_features f

    ON h.Ticker = f.Ticker

    GROUP BY f.Date
),

running_peak AS
(
    SELECT

        *,

        MAX(Portfolio_Value)
        OVER(
            ORDER BY Date
        ) AS Running_Peak

    FROM portfolio_valuation
)

SELECT

    Date,

    Portfolio_Value,

    Running_Peak,

    ROUND(
        Running_Peak - Portfolio_Value,
        2
    ) AS Drawdown,

    ROUND(
        (
            Running_Peak
            -
            Portfolio_Value
        )
        /
        Running_Peak
        *100,
        2
    ) AS Drawdown_Percentage

FROM running_peak

ORDER BY Drawdown_Percentage DESC

LIMIT 1;
