WITH CTE1 AS
(Select *,
CASE 
	when promo_type ='50% OFF' then base_price/2
    when promo_type ='25% OFF' then base_price*0.75
    when promo_type ='33% OFF' then base_price*0.67
    when promo_type ='500 Cashback' then (base_price-500)
    when promo_type ='BOGOF' then base_price*0.5
END as promo_price,
CASE
	when promo_type ='BOGOF' then `quantity_sold(after_promo)`*2
    else `quantity_sold(after_promo)`
END as promo_quantity
from fact_events),
CTE2 AS
(select p.product_name,C1.product_code,p.category,
SUM(base_price * `quantity_sold(before_promo)`)/1000000
as Total_Revenue_mln_before_promo,
SUM(promo_price* promo_quantity)/1000000
as Total_Revenue_mln_after_promo
from CTE1 C1
join dim_products p
using(product_code)
group by p.product_code
order by Total_Revenue_mln_after_promo desc
)select product_name,category,
ROUND(((Total_Revenue_mln_after_promo -Total_Revenue_mln_before_promo)/Total_Revenue_mln_before_promo)*100,2)
as IR_percent  
from CTE2
order by IR_percent desc
limit 5;

