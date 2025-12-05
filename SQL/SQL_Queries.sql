-- ============================================================
-- GLOBAL RESTAURANT PERFORMANCE & BUSINESS ANALYTICS
-- SQL Business Questions for PostgreSQL
-- ============================================================
-- ============================================================
-- LEVEL 1: FOUNDATIONAL ANALYSIS
-- ============================================================

/* Q1: What are the top 5 most popular cuisines by restaurant count,
       and what is their average rating?*/
select
cuisines,
count(restaurant_id) as total_restaurants,
round(avg(rating)::numeric,2) as avg_ratings
from restaurant
group by cuisines
order by total_restaurants desc limit 5;

/* Q2: Identify the top 10 cities by restaurant count and 
       calculate each city's average rating and total votes.*/
select
city,
count(restaurant_id) as total_restaurants,
round(avg(rating)::numeric,2) as avg_ratings,
sum(votes) as total_votes
from restaurant
group by city
order by total_restaurants desc limit 10;


/* Q3: What is the distribution of restaurants across price ranges and 
       price categories, and what percentage does each represent? */
select
price_range,
price_category,
count(restaurant_id) as restaurants,
Round((count(restaurant_id)/sum(count(restaurant_id))over())*100,2) as restaurant_percentage
from restaurant
group by price_range,price_category
order by price_range;


/* Q4: Calculate the percentage of restaurants offering online delivery,
       table booking, and both services. */
with totals as(
select
count(*) as total_restaurants
from restaurant
)
select
'Online Delivery' as category,
count(*),
round((count(*)*100.0/(select total_restaurants from totals)),2) as percentage
from restaurant
where online_delivery = 'Yes'
UNION ALL
select
'Table Booking' as category,
count(*),
round((count(*)*100.0/(select total_restaurants from totals)),2) as percentage
from restaurant
where table_booking = 'Yes'
UNION ALL
select
'Both Services' as category,
count(*),
round((count(*)*100.0/(select total_restaurants from totals)),2) as percentage
from restaurant
where online_delivery = 'Yes' and table_booking = 'Yes';

-- Q5: What is the average number of votes per restaurant in each rating category (rating_text)?
select
rating_text,
count(restaurant_id) as restaurant_count,
round(avg(votes)) as avg_votes
from restaurant
group by rating_text
order by avg_votes desc;

-- ============================================================
-- LEVEL 2: COMPARATIVE & SEGMENTATION ANALYSIS
-- ============================================================

-- Q6: Compare average ratings and median votes between restaurants with and without online delivery.
select
'Online Delivery' as delivery_mode,
count(*) as total_restaurants,
round(avg(rating)::numeric,2) as avg_rating,
percentile_cont(0.5) within group(order by votes) as median_votes
from restaurant
where online_delivery = 'Yes'
UNION ALL
select
'No-Online Delivery' as delivery_mode,
count(*) as total_restaurants,
round(avg(rating)::numeric,2) as avg_rating,
percentile_cont(0.5) within group(order by votes) as median_votes
from restaurant
where online_delivery = 'No';

-- Q7: Find the top 3 cities in each country ranked by average rating.
with top_city as (
select
country,
trim(city) as city,
avg(rating) as avg_rating,
row_number()over(partition by country order by avg(rating) desc) as rn
from restaurant
group by country, city
)
select
country, city, 
round(avg_rating::numeric,1) as avg_rating
from top_city where rn <= 3;

/*Q8: What is the relationship between num_cuisines (variety) and average rating?
       Do multi-cuisine restaurants perform better?*/
select
count(restaurant_name) as total_restaurants,
num_cuisines,
round(avg(rating)::numeric,2) as avg_rating,
case
when num_cuisines>=5 and avg(rating)>=3 then 'strong positive'
when num_cuisines>=5 and avg(rating)<3 then 'weak positive'
when num_cuisines between 3 and 4 and avg(rating)>=3 then 'moderate positive'
when num_cuisines<3 and avg(rating)>=3 then 'specialised strong'
else 'no relation'
end as relation
from restaurant
group by num_cuisines
order by avg_rating desc;

/* Q9: Calculate the average cost difference between price categories and 
       identify which category offers the best rating-to-cost ratio.*/
select
price_range,
price_category,
round(avg(avg_cost)::numeric,1)as avg_cost,
round(avg(rating)::numeric,2) as avg_rating,
round((avg(avg_cost)/avg(rating))::numeric,2) as rating_to_cost_ratio
from restaurant
group by price_range, price_category
order by price_range;

-- Q10: Identify restaurants that are priced above their city's average cost but have ratings above 4.0 (premium performers).
with cte as (
select
restaurant_name,
city,
avg_cost AS restaurant_cost,
round(avg(avg_cost) over(partition by city)) as city_avg_cost,
rating
from restaurant
)
select
*
from cte 
where restaurant_cost > city_avg_cost and rating > 4.0;


-- ============================================================
-- LEVEL 3: ADVANCED INSIGHTS & COMPLEX ANALYSIS
-- ============================================================

-- Q11: Rank restaurants within each city by votes and identify the top 3 most popular restaurants per city with their key metrics.
with top_rest as (
select
restaurant_name, city, votes, rating, avg_cost,
num_cuisines, online_delivery, table_booking,
row_number() over(partition by city order by votes desc) as ranks
from restaurant
)
select
*
from top_rest
where ranks <=3;

-- Q12: Calculate a "value score" and identify the top 20 high-value restaurants across all segments.
select
restaurant_name,
rating,
price_range,
round((rating/price_range)::numeric,1) as value_score
from restaurant
order by value_score desc limit 20;

-- Q13: Find cities that have either above-average restaurant density OR above-average rating.
with top_city as (
select
city,
count(restaurant_name) as restaurant_density,
avg(rating) as avg_rating
from restaurant
group by city
),
avgs as(
select
avg(restaurant_density) as avg_density,
avg(avg_rating) as avg_city_rating
from top_city
)
select
city,
restaurant_density,
round(avg_rating) as rating
from top_city 
where restaurant_density > (select avg_density from avgs)
or avg_rating >=(select avg_city_rating from avgs)
order by restaurant_density desc;

-- Q14: Analyze service adoption: does price_range correlate with the likelihood of offering table_booking and online_delivery services?
select
price_range,
count(*) as total_restaurants,
sum(case when table_booking = 'Yes' then 1 else 0 end) as table_booking_count,
sum(case when online_delivery = 'Yes' then 1 else 0 end) as online_delivery_count,
concat(round(sum(case when table_booking = 'Yes' then 1 else 0 end)*100.0/count(*),1),'%') as table_booking_pct,
concat(round(sum(case when online_delivery = 'Yes' then 1 else 0 end)*100.0/count(*),1),'%') as online_delivery_pct
from restaurant
group by price_range
order by price_range;


/*Q15:Identify underperforming opportunities: cities with high restaurant counts(>20) but average ratings below 3.5,
  grouped by price category */
with cte as (
select
city,
price_category,
count(restaurant_name) as restaurant_counts,
round(avg(rating)::numeric,2) as avg_rating
from restaurant
group by city,price_category
)
select 
*
from cte
where restaurant_counts > 20 and avg_rating < 3.5;






