SELECT * FROM retail_events_db.dim_products;

select distinct(product_name),base_price from dim_products p
join fact_events e
on p.product_code =e.product_code
where base_price>500 and promo_type ="BOGOF";