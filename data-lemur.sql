--1. Histogram of Tweets [Twitter SQL Interview Question]
with tweets_per_user as (
  SELECT count(*) as num_tweets
  FROM tweets
  WHERE EXTRACT(YEAR from tweet_date) = 2022
  GROUP BY user_id
  ORDER BY count(*)
)

select 
  num_tweets as tweet_bucket,
  count(*) as users_num
from tweets_per_user
group by tweet_bucket;





--2. Data Science Skills [LinkedIn SQL Interview Question]
SELECT candidate_id, count(*) as count_skills
FROM candidates
WHERE skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING count(*) >= 3;





--3. Page With No Likes [Facebook SQL Interview Question]
with pages_with_likes as (
  SELECT page_id, count(*)
  FROM page_likes
  GROUP BY page_id
)

select pages.page_id from pages 
left join pages_with_likes 
on pages.page_id=pages_with_likes.page_id
where pages_with_likes.page_id is NULL
ORDER BY pages.page_id;





--4. Unfinished Parts [Tesla SQL Interview Question]
SELECT part, finish_date 
FROM parts_assembly
where finish_date is null;





--5. Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
select
  (
    select count(*) 
    from viewership
    where device_type in ('laptop')
  ) as laptop_views,
  (
    select count(*) 
    from viewership
    where device_type in ('tablet', 'phone')
  ) as mobile_views





--6. Average Post Hiatus (Part 1) [Facebook SQL Interview Question]
with cte as (
  SELECT user_id, count(*) AS count_posts
  FROM posts
  WHERE EXTRACT(YEAR FROM post_date) = 2021
  GROUP BY user_id
  HAVING count(*) >= 2
)

select 
  posts.user_id, 
  DATE_PART('days', MAX(posts.post_date)-MIN(posts.post_date)) AS days_between
from posts
JOIN cte ON cte.user_id = posts.user_id
group by posts.user_id;





--7. Teams Power Users [Microsoft SQL Interview Question]
SELECT sender_id, count(*) as message_count 
FROM messages
GROUP BY sender_id
ORDER BY count(*) DESC
LIMIT 2;





--8. Duplicate Job Listings [Linkedin SQL Interview Question]
with dupl_cte as 
(
  SELECT company_id, count(*)
  FROM job_listings
  GROUP BY company_id
  HAVING count(*) >= 2
)

SELECT count(*) as duplicate_companies
FROM dupl_cte;





--9. Cities With Completed Trades [Robinhood SQL Interview Question]
SELECT city, count(*) 
FROM trades
JOIN users ON trades.user_id = users.user_id
WHERE status='Completed'
GROUP BY city
ORDER BY count(*) DESC
LIMIT 3;





--10. Average Review Ratings [Amazon SQL Interview Question]
SELECT 
  EXTRACT(MONTH FROM submit_date) as mth, 
  product_id as product, 
  ROUND(AVG(stars), 2) as avg_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product;





--11. App Click-through Rate (CTR) [Facebook SQL Interview Question]
SELECT 
  app_id,
  ROUND(
    100.0 * 
    SUM(CASE WHEN event_type = 'click' THEN 1 END) / 
    SUM(CASE WHEN event_type = 'impression' THEN 1 END), 
  2) as ctr
FROM events
GROUP BY app_id;





--12. Second Day Confirmation [TikTok SQL Interview Question]
SELECT user_id
FROM emails
JOIN texts ON emails.email_id = texts.email_id
WHERE 
  signup_action = 'Confirmed' AND
  signup_date + interval '1' day = action_date
ORDER BY emails.email_id;





--13.Cards Issued Difference [JPMorgan Chase SQL Interview Question]
SELECT 
  card_name, 
  MAX(issued_amount)-MIN(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;