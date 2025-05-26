

                   ### Business Query and Solve ###

#Q1. Find difference payment method and number of transactions, number of qty sold

Select
distinct payment_method,
Count(*) as no_payments,
sum(quantity) as no_qty_sold
from walmart
Group by payment_method;


#Q2. Identify the highest-rated category in each brach, displaying the branch, category,AVG rating
select * 
from
(select 
Branch,
category,
avg (rating) as avg_rating,
Rank() over(partition by Branch order by avg(rating) desc) as ranking
from walmart
group by 1,2
) as t1
where t1.ranking = 1;








# Q3. Identify the busiest day for each branch based on the number of transactions
 #DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%Y-%m-%d') AS formatted_date --Text to date format function
 
 Select * From
 
(SELECT 
    Branch,
    DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS Day_name,
    count(*) as no_transactions,
    DENSE_RANK () OVER(Partition by Branch order by count(*) desc) as Ranking
FROM walmart
Group by 1,2
order by 1,3 desc
) as t1
Where t1.Ranking=1;


#Q4. Calculate the total quantity of items sold per payment method, List payment method and total_quantity

Select
payment_method,
sum(quantity) as no_qty_sold
from walmart
group by payment_method;

#Q5. Determine the average , minimum, and maximum rating of products for each city.
#list the city,average_rating,min_rating and Max_rating.

Select
City,
category,
min(rating) as Min_Rating,
max(rating) as Max_Rating,
avg(rating) as Avg_Rating,
DENSE_RANK() OVER(Partition by City order by avg(rating) desc) as Ranking

from walmart
group by City,category;

#Q6. Calculate the total profit for each category by considering total_profit as 
#(unit_price*quantity*profit_margin). List category and total_profit,order from higest to lowest profit.alter

select
category,
sum(total) as total_revenue,
sum(total*profit_margin) as profit
from walmart
group by category;

#Q7 Determine the most common payment method for each branch, Display Brancha and the preferred_payment_method.

With cte as
(select 
Branch,
payment_method,
count(*) as total_transaction,
RANK() Over(partition by Branch order by count(*) desc) as Ranking
from walmart
group by Branch, payment_method
)
select * from cte where Ranking=1;

#Q8. categorize sales into 3 group morning ,afternoon,evening
# Find out which of the shift and number of invoices 

Select 
Branch,
CASE
		WHEN HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
		END AS time_period,
        count(*) as Transaction_count
FROM walmart
group by Branch,time_period
order by Branch,Transaction_count desc;

#Q9. Identify 5 branch with highest decrese ration in revenue compare to last year(current year 2023 and last year 2022)

With revenue_2022 
as
(Select
    Branch,
    SUM(total) AS revenue
from walmart
where year(STR_TO_DATE(date, '%d/%m/%y')) = 2022
Group by Branch
),

revenue_2023
as
(Select
    Branch,
    SUM(total) AS revenue
from walmart
where year(STR_TO_DATE(date, '%d/%m/%y')) = 2023
Group by Branch
)
Select 
ls.Branch,
ls.revenue as last_year_revenue,
cs.revenue as current_year_revenue,
Round((ls.revenue-cs.revenue)/ls.revenue * 100,2) as revenue_decrese_ratio
from revenue_2022 as ls
join
revenue_2023 as cs
ON ls.Branch=cs.Branch
Where ls.revenue > cs.revenue
order by 4 desc
limit 5;






