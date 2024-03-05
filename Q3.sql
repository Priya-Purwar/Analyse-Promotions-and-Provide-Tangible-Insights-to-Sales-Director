WITH CTE AS (
SELECT *,
CASE 
	when promo_type ='50% OFF' then base_price*0.5
    when promo_type ='25% OFF' then base_price*0.75
    when promo_type ='33% OFF' then base_price*0.67
    when promo_type ='500 Cashback' then (base_price-500)
    when promo_type ='BOGOF' then base_price*0.5
END as promo_price,
CASE
	when promo_type ='BOGOF' then `quantity_sold(after_promo)`*2
    else `quantity_sold(after_promo)`
END as promo_quantity
FROM fact_events f
)
select campaign_name,
ROUND(SUM(base_price * `quantity_sold(before_promo)`)/1000000,2)
as Total_Revenue_mln_before_promo,
ROUND(SUM(promo_price* promo_quantity)/1000000,2) 
as Total_Revenue_mln_after_promo
from CTE 
join dim_campaigns c
using(campaign_id)
group by campaign_name;
