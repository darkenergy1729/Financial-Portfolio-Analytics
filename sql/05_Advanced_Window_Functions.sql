/*
===============================================================================
Project      : Financial Portfolio Analytics
Author       : Puneet Kaur
Database     : MySQL

File         : 05_Advanced_Window_Functions.sql

Description:
This script demonstrates advanced SQL window functions used throughout
the Financial Portfolio Analytics project.

Business Questions Answered
---------------------------
1. How can stocks be ranked based on performance?
2. How much did the portfolio change compared to the previous trading day?
3. What percentage of total profit does each stock contribute?
4. What was the highest portfolio value reached over time?
5. What is the rolling 30-day average portfolio value?

SQL Skills Demonstrated
-----------------------
• RANK()
• LAG()
• SUM() OVER()
• MAX() OVER()
• AVG() OVER()
• Window Frames
===============================================================================
*/

USE financial_portfolio;

-- ============================================================================
-- Window Function 1 : RANK()
-- Rank stocks based on return percentage
-- ============================================================================

WITH portfolio_returns AS
(
    SELECT

        h.Ticker,
        h.Company,

        ROUND(
            (
                (h.`Shares Purchased` * f.`Adj Close`)
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
        ON h.Ticker = f.Ticker

    WHERE f.Date =
    (
        SELECT MAX(Date)
        FROM stock_data_features
    )
)

SELECT

    *,

    RANK() OVER(
        ORDER BY Return_Percentage DESC
    ) AS Performance_Rank

FROM portfolio_returns;



-- ============================================================================
-- Window Function 2 : LAG()
-- Compare portfolio value with previous trading day
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
)

SELECT

    Date,

    Portfolio_Value,

    LAG(Portfolio_Value)
    OVER(
        ORDER BY Date
    ) AS Previous_Day_Value

FROM portfolio_value;



-- ============================================================================
-- Window Function 3 : SUM() OVER()
-- Calculate each stock's contribution to total portfolio profit
-- ============================================================================

WITH stock_profit AS
(
    SELECT

        h.Ticker,

        h.Company,

        ROUND(
            (h.`Shares Purchased` * f.`Adj Close`)
            -
            h.`Investment Amount`,
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

profit_contribution AS
(
    SELECT

        *,

        SUM(Profit)
        OVER() AS Total_Profit

    FROM stock_profit
)

SELECT

    *,

    ROUND(
        Profit / Total_Profit *100,
        2
    ) AS Contribution_Percentage

FROM profit_contribution;



-- ============================================================================
-- Window Function 4 : MAX() OVER()
-- Running Peak used for Maximum Drawdown
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
)

SELECT

    *,

    MAX(Portfolio_Value)
    OVER(
        ORDER BY Date
    ) AS Running_Peak

FROM portfolio_value;



-- ============================================================================
-- Window Function 5 : AVG() OVER()
-- Rolling 30-Day Portfolio Average
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
)

SELECT

    Date,

    Portfolio_Value,

    ROUND(

        AVG(Portfolio_Value)
        OVER
        (
            ORDER BY Date

            ROWS BETWEEN 29 PRECEDING
            AND CURRENT ROW
        ),

        2

    ) AS Rolling_30_Day_Average

FROM portfolio_value

ORDER BY Date;
