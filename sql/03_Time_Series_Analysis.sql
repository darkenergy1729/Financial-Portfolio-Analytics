/*
===============================================================================
Project      : Financial Portfolio Analytics
Author       : Puneet Kaur
Database     : MySQL

File         : 03_Time_Series_Analysis.sql

Description:
This script analyzes the portfolio's performance over time. It calculates
daily portfolio value, day-over-day changes, daily returns, and identifies
the best and worst trading days.

Business Questions Answered
---------------------------
1. How has the portfolio value changed over time?
2. What was the portfolio worth on each trading day?
3. What was the daily profit or loss?
4. What was the daily percentage return?
5. Which were the best and worst trading days?

SQL Skills Demonstrated
-----------------------
• JOIN
• GROUP BY
• Aggregate Functions
• Common Table Expressions (CTEs)
• Window Functions (LAG)
===============================================================================
*/

USE financial_portfolio;



-- ============================================================================
-- Dataset Coverage
-- Displays available historical date range
-- ============================================================================

SELECT
    MIN(Date) AS Start_Date,
    MAX(Date) AS End_Date,
    COUNT(DISTINCT Date) AS Trading_Days
FROM stock_data_features;



-- ============================================================================
-- Latest Available Date for Each Stock
-- ============================================================================

SELECT
    Ticker,
    MAX(Date) AS Latest_Date
FROM stock_data_features
GROUP BY Ticker
ORDER BY Ticker;



-- ============================================================================
-- Daily Portfolio Value
-- Calculates total portfolio market value for each trading day
-- ============================================================================

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

ORDER BY f.Date;



-- ============================================================================
-- Portfolio Value with Previous Day Value
-- ============================================================================

WITH daily_portfolio AS
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
)

SELECT

    Date,

    Portfolio_Value,

    LAG(Portfolio_Value)
    OVER(
        ORDER BY Date
    ) AS Previous_Day_Value

FROM daily_portfolio;



-- ============================================================================
-- Daily Portfolio Change and Daily Return
-- ============================================================================

WITH portfolio_value AS
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

daily_change AS
(
    SELECT

        *,

        LAG(Portfolio_Value)
        OVER(
            ORDER BY Date
        ) AS Previous_Day_Value

    FROM portfolio_value
)

SELECT

    Date,

    Portfolio_Value,

    Previous_Day_Value,

    ROUND(
        COALESCE(
            Portfolio_Value - Previous_Day_Value,
            0
        ),
        2
    ) AS Daily_Change,

    COALESCE(

        ROUND(

            (
                Portfolio_Value
                -
                Previous_Day_Value
            )

            /

            Previous_Day_Value

            *100,

            2

        ),

        0

    ) AS Daily_Return

FROM daily_change

ORDER BY Date;



-- ============================================================================
-- Top 5 Best Trading Days
-- ============================================================================

WITH portfolio_value AS
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

daily_change AS
(
    SELECT

        *,

        LAG(Portfolio_Value)
        OVER(
            ORDER BY Date
        ) AS Previous_Day_Value

    FROM portfolio_value
)

SELECT

    Date,

    Portfolio_Value,

    ROUND(
        Portfolio_Value - Previous_Day_Value,
        2
    ) AS Daily_Change,

    ROUND(
        (
            Portfolio_Value
            -
            Previous_Day_Value
        )
        /
        Previous_Day_Value
        *100,
        2
    ) AS Daily_Return

FROM daily_change

WHERE Previous_Day_Value IS NOT NULL

ORDER BY Daily_Change DESC

LIMIT 5;



-- ============================================================================
-- Top 5 Worst Trading Days
-- ============================================================================

WITH portfolio_value AS
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

daily_change AS
(
    SELECT

        *,

        LAG(Portfolio_Value)
        OVER(
            ORDER BY Date
        ) AS Previous_Day_Value

    FROM portfolio_value
)

SELECT

    Date,

    Portfolio_Value,

    ROUND(
        Portfolio_Value - Previous_Day_Value,
        2
    ) AS Daily_Change,

    ROUND(
        (
            Portfolio_Value
            -
            Previous_Day_Value
        )
        /
        Previous_Day_Value
        *100,
        2
    ) AS Daily_Return

FROM daily_change

WHERE Previous_Day_Value IS NOT NULL

ORDER BY Daily_Change ASC

LIMIT 5;
