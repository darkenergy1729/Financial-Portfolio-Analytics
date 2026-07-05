/*
===============================================================================
Project      : Financial Portfolio Analytics
Author       : Puneet Kaur
Database     : MySQL

File         : 02_Performance_Analysis.sql

Description:
This script evaluates the current performance of the investment portfolio.
It calculates current market value, profit/loss, return percentage,
stock rankings, top-performing investments, and sector performance.

Business Questions Answered
---------------------------
1. What is the current value of each investment?
2. How much profit has each stock generated?
3. Which stocks generated the highest returns?
4. Which stocks contributed the most to portfolio performance?
5. Which sectors are performing the best?

SQL Skills Demonstrated
-----------------------
• JOIN
• Aggregate Functions
• CTEs
• Subqueries
• Window Functions (RANK)
===============================================================================
*/

USE financial_portfolio;



-- ============================================================================
-- Latest Available Trading Date
-- ============================================================================

SELECT
    MAX(Date) AS Latest_Trading_Date
FROM stock_data_features;



-- ============================================================================
-- Current Portfolio Value
-- Displays current market price and current value of every stock
-- ============================================================================

SELECT

    h.Ticker,
    h.Company,
    h.`Shares Purchased`,

    ROUND(f.`Adj Close`,2) AS Current_Price,

    ROUND(
        h.`Shares Purchased` * f.`Adj Close`,
        2
    ) AS Current_Value

FROM portfolio_holdings h

JOIN stock_data_features f

ON h.Ticker = f.Ticker

WHERE f.Date =
(
    SELECT MAX(Date)
    FROM stock_data_features
)

ORDER BY Current_Value DESC;



-- ============================================================================
-- Portfolio Profit Analysis
-- Calculates investment, current value and total profit
-- ============================================================================

SELECT

    h.Ticker,
    h.Company,

    ROUND(
        h.`Investment Amount`,
        2
    ) AS Investment,

    ROUND(
        f.`Adj Close`,
        2
    ) AS Current_Price,

    h.`Shares Purchased`,

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

ORDER BY Profit DESC;



-- ============================================================================
-- Portfolio Return Percentage
-- ============================================================================

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
        (
            ( h.`Shares Purchased` * f.`Adj Close`) 
              - h.`Investment Amount`)/h.`Investment Amount`*100,2 ) AS Return_Percentage

FROM portfolio_holdings h

JOIN stock_data_features f

ON h.Ticker=f.Ticker

WHERE f.Date=
(
    SELECT MAX(Date)
    FROM stock_data_features
)

ORDER BY Return_Percentage DESC;



-- ============================================================================
-- Rank Stocks Based on Return Percentage
-- ============================================================================

WITH portfolio_returns AS
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
            (
                (
                    h.`Shares Purchased` * f.`Adj Close`
                ) -h.`Investment Amount`)/h.`Investment Amount`*100, 2 ) AS Return_Percentage

    FROM portfolio_holdings h

    JOIN stock_data_features f

    ON h.Ticker=f.Ticker

    WHERE f.Date=
    (
        SELECT MAX(Date)
        FROM stock_data_features
    )
)

SELECT

    *,

    RANK()
    OVER(
        ORDER BY Return_Percentage DESC
    ) AS Performance_Rank

FROM portfolio_returns;



-- ============================================================================
-- Top 3 Performing Stocks
-- ============================================================================

WITH portfolio_returns AS
(
    SELECT

        h.Ticker,
        h.Company,

        ROUND(
            (
                (
                    h.`Shares Purchased`
                    *
                    f.`Adj Close`
                )
                -
                h.`Investment Amount`
            )
            /
            h.`Investment Amount`
            *100,
            2
        ) AS Return_Percentage

    FROM portfolio_holdings h

    JOIN stock_data_features f

    ON h.Ticker=f.Ticker

    WHERE f.Date=
    (
        SELECT MAX(Date)
        FROM stock_data_features
    )
)

SELECT *

FROM portfolio_returns

ORDER BY Return_Percentage DESC

LIMIT 3;



-- ============================================================================
-- Sector Performance Analysis
-- ============================================================================

SELECT

    h.Sector,

    ROUND(
        SUM(h.`Investment Amount`),
        2
    ) AS Total_Investment,

    ROUND(
        SUM(
            h.`Shares Purchased`
            *
            f.`Adj Close`
        ),
        2
    ) AS Current_Value,

    ROUND(
        SUM(
            (
                h.`Shares Purchased`
                *
                f.`Adj Close`
            )
            -
            h.`Investment Amount`
        ),
        2
    ) AS Total_Profit,

    ROUND(
        SUM(
            (
                h.`Shares Purchased`
                *
                f.`Adj Close`
            )
            -
            h.`Investment Amount`
        )
        /
        SUM(h.`Investment Amount`)
        *100,
        2
    ) AS Return_Percentage

FROM portfolio_holdings h

JOIN stock_data_features f

ON h.Ticker=f.Ticker

WHERE f.Date=
(
    SELECT MAX(Date)
    FROM stock_data_features
)

GROUP BY h.Sector

ORDER BY Return_Percentage DESC;
