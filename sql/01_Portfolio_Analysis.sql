/*
===============================================================================
Project      : Financial Portfolio Analytics
Author       : Puneet Kaur
Database     : MySQL

File         : 01_Portfolio_Analysis.sql

Description:
This script provides a high-level overview of the investment portfolio.
It calculates key portfolio statistics including total investment,
average investment, number of holdings, top investments, and
sector-wise allocation.

Business Questions Answered
---------------------------
1. How many stocks are in the portfolio?
2. How much capital has been invested?
3. What is the average investment per stock?
4. Which stocks have the highest and lowest investment?
5. How is the investment distributed across sectors?

SQL Skills Demonstrated
-----------------------
• SELECT
• DISTINCT
• Aggregate Functions
• GROUP BY
• ORDER BY
• LIMIT
===============================================================================
*/

USE financial_portfolio;



-- ============================================================================
-- Portfolio Holdings
-- Displays all holdings in the portfolio
-- ============================================================================

SELECT *
FROM portfolio_holdings;



-- ============================================================================
-- Remove Duplicate Records
-- ============================================================================

SELECT DISTINCT *
FROM portfolio_holdings;



-- ============================================================================
-- Total Number of Holdings
-- ============================================================================

SELECT
    COUNT(*) AS Total_Holdings
FROM portfolio_holdings;



-- ============================================================================
-- Total Capital Invested
-- ============================================================================

SELECT
    ROUND(SUM(`Investment Amount`),2) AS Total_Investment
FROM portfolio_holdings;



-- ============================================================================
-- Average Investment per Stock
-- ============================================================================

SELECT
    ROUND(AVG(`Investment Amount`),2) AS Average_Investment
FROM portfolio_holdings;



-- ============================================================================
-- Top 3 Highest Investments
-- ============================================================================

SELECT

    Ticker,
    Company,
    `Investment Amount`

FROM portfolio_holdings

ORDER BY `Investment Amount` DESC

LIMIT 3;



-- ============================================================================
-- Bottom 3 Lowest Investments
-- ============================================================================

SELECT

    Ticker,
    Company,
    `Investment Amount`

FROM portfolio_holdings

ORDER BY `Investment Amount`

LIMIT 3;



-- ============================================================================
-- Sector-wise Total Investment
-- ============================================================================

SELECT

    Sector,

    ROUND(
        SUM(`Investment Amount`),
        2
    ) AS Total_Investment

FROM portfolio_holdings

GROUP BY Sector

ORDER BY Total_Investment DESC;



-- ============================================================================
-- Number of Companies in Each Sector
-- ============================================================================

SELECT

    Sector,

    COUNT(Company) AS Total_Companies

FROM portfolio_holdings

GROUP BY Sector

ORDER BY Total_Companies DESC;



-- ============================================================================
-- Sector Summary
-- Total Companies
-- Total Investment
-- Average Investment
-- ============================================================================

SELECT

    Sector,

    COUNT(Company) AS Total_Companies,

    ROUND(
        SUM(`Investment Amount`),
        2
    ) AS Total_Investment,

    ROUND(
        AVG(`Investment Amount`),
        2
    ) AS Average_Investment

FROM portfolio_holdings

GROUP BY Sector

ORDER BY Total_Investment DESC;
