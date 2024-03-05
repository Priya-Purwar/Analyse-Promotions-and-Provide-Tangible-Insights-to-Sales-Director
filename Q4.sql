WITH CTE1 AS
	(Select campaign_id,category,`quantity_sold(before_promo)`,
	CASE
		when promo_type ='BOGOF' then (`quantity_sold(after_promo)`)*2
		else `quantity_sold(after_promo)`
	END as promo_quantity
	from dim_products p
	join fact_events f
	on p.product_code =f.product_code
    ),
CTE2 AS 
	(Select category,campaign_id,
    SUM(promo_quantity -`quantity_sold(before_promo)`)*100/SUM(`quantity_sold(before_promo)`)
	as ISU_percentage 
    from CTE1
    group by category,campaign_id
    )
    Select category,ISU_percentage,rank() over(order by ISU_percentage desc) rnk
    from CTE2
    where campaign_id ='CAMP_DIW_01';