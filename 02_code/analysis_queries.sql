-- Make the database
CREATE DATABASE marketing_analysis;

-- Use the database
USE marketing_analysis;

-- I used MySQL Workbench's table data import wizard to import the .csv files 
-- into the database. Since the dataframes are small, this is fine to do. 
-- You're welcome to do it however you see fit.

-- Drop the previous calculated columns so that you can calculate them here in SQL
CREATE TABLE data_to_calculate AS
SELECT channel,
       impressions,
       `CPM ($)`,
       `pre_campaign_click_through`,
       `click-through`,
       `click-through_rate (%)`,
       `CPC ($)`,
       conversions FROM cac_calc;

-- Calculates the cost per impression
SELECT impressions*`CPM ($)` / 1000 AS cost_per_impression_total FROM data_to_calculate;

-- Calculates the click through rate
SELECT `click-through`/impressions * 100 AS `click_through_rate(%)` FROM data_to_calculate;

-- Let's say we had impressions and click-throughs prior to a 
-- big marketing campaign and after a big marketing campaign.
-- Impressions and click-throughs prior to the campaign could be for example just 
-- general facebook posts and such. How does click-through 
-- (AKA visits to site or CTA CTR) respond to the new marketing initiative?

-- Calculates CPV (cost per visit) (USD)
SELECT ( `CPC ($)` + `CPM ($)` ) / ( `click-through` / pre_campaign_click_through ) 
AS `CPV ($)` from data_to_calculate;

-- Calculates total cost per clicks
SELECT `CPC ($)`*`click-through` 
AS CPC_total FROM data_to_calculate;

-- The cheapest and most fruitful channels to focus marketing campaign efforts on
SELECT * FROM cac_calc
ORDER BY conversions DESC;

-- Based on this analysis, twitter and linkedin campaigns should be 
-- iterated on to improve metrics accross the board and further boost conversions

-- Determine the LTV of the average customer
SELECT AVG(total_purchases_per_month)
*AVG(purchases_per_month)
*AVG(`customer_duration (months)`) 
AS LTV FROM LTV_calc;

-- Subtracting out the average CAC (cost to acquire a customer) gets the net worth 
-- LTV of the average customer:
SELECT AVG(total_purchases_per_month)
*AVG(purchases_per_month)
*AVG(`customer_duration (months)`) - 15.65 FROM LTV_calc;

-- Numbers are highly variable between channels, so it would be good to run these 
-- queries on each channel to see what the ROI is for each and what the net 
-- worth is for a customer from each.