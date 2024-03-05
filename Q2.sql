SELECT * FROM retail_events_db.dim_stores;

select city,count(store_id) as Stores_count from dim_stores
group by city 
order by Stores_count desc;