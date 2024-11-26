-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?


-- Finding the receipt status with most spent by keeping the first row from the ranked subquery 
SELECT most_spent.rewardsReceiptStatus
FROM 
(
-- Ranking over by the avg spend in descending order, dense_rank() to cover ties
SELECT 
	avg_spend.*,
	DENSE_RANK() OVER(ORDER BY avg_spend desc) AS R
FROM 
(
-- Find the average spend
SELECT 
	  total_spend.rewardsReceiptStatus
    , total_spend.total_spent/total_spend.total_items AS avg_spend
FROM (
-- Findidng the total spent and items to get the average
SELECT 
	  rewardsReceiptStatus
    , SUM(totalSpent) AS total_spent
    , SUM(purchasedItemCount) as total_items FROM receipts
WHERE 
	  rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
	  rewardsReceiptStatus) AS total_spend) AS avg_spend) AS most_spent
      WHERE most_spent.R = 1;



-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?   


-- Finding the receipt status with most purchased by keeping the first row from the ranked subquery 
SELECT most_purchased.rewardsReceiptStatus
FROM
(
-- Ranking over by the total items in descending order, dense_rank() to cover ties
SELECT 
	  total_purchased.*
	, DENSE_RANK() OVER(ORDER BY total_count DESC) AS R
FROM 
(
-- Findidng the total purchased items to get the average
SELECT 
	  rewardsReceiptStatus
	, SUM(purchasedItemCount) AS total_count
FROM 
	  receipts 
WHERE 
	  rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
	  rewardsReceiptStatus) AS total_purchased) AS most_purchased
WHERE most_purchased = 1