SELECT *
FROM RATING

-- --## Movie Database Joins Exercise 

-- See the file movies_erd for table and column info.

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT s.film_title, s.release_year, r.worldwide_gross
FROM specs As s
INNER JOIN revenue AS r
USING (movie_id)
ORDER BY r.worldwide_gross
LIMIT 1;
 --answer:"Semi-Tough"	1977	37187139

-- 2. What year has the highest average imdb rating?
SELECT s.release_year, AVG(r.imdb_rating) as avg_rating
FROM specs As s
INNER JOIN rating AS r
USING (movie_id)
GROUP BY s.release_year
ORDER BY avg_rating DESC
LIMIT 1;
--answer: 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT s.film_title, r.worldwide_gross,d.company_name
FROM specs As s
INNER JOIN revenue AS r
USING (movie_id)
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
WHERE s.mpaa_rating IN ('G')
ORDER BY r.worldwide_gross DESC
LIMIT 1;
--"Toy Story 4"	distributed by	"Walt Disney "

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT d.company_name, COUNT(s.domestic_distributor_id) AS movie_num
FROM distributors AS d
FULL JOIN specs as s
ON s.domestic_distributor_id = d.distributor_id
GROUP BY d.company_name 
ORDER BY movie_num DESC;


-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT d.company_name, AVG(r.film_budget) AS avg_movie_budget
FROM distributors AS d
INNER JOIN specs as s
ON D.distributor_id = S.domestic_distributor_id
INNER JOIN revenue AS r
ON s.movie_id= r.movie_id
GROUP BY d.company_name
ORDER BY avg_movie_budget DESC
limit 5;


-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?


SELECT s.film_title, r.imdb_rating, COUNT(s.domestic_distributor_id) AS movie_num
FROM distributors AS d
INNER JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
INNER JOIN rating AS r
ON s.movie_id= r.movie_id 
WHERE d.headquarters <> '%CA'
GROUP BY r.imdb_rating, s.film_title	
ORDER BY r.imdb_rating DESC

--answer:419 movie are distributed by a company not hedquarterd in CA. The Dark Knight has the highest imdb rating.

-- SELECT s.flm_title, r.imdb_rating
-- FROM specs
-- (SELECT COUNT(s.domestic_distributor_id) AS movie_num
-- FROM distributors AS d
-- INNER JOIN specs as s
-- ON d.distributor_id = s.domestic_distributor_id
-- WHERE d.headquarters <> '%CA'
-- INNER JOIN rating AS r
-- ON s.movie_id= r.movie_id) AS sub
-- ORDER BY r.imdb_rating



-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT movie_length, AVG(avg_rating) AS avg_rating_overall
FROM
(SELECT s.length_in_min,AVG(r.imdb_rating) AS avg_rating,
	CASE WHEN s.length_in_min > 120 THEN 'Movie is longer than 2hrs'
	WHEN s.length_in_min < 120 THEN 'Movie is shorter than 2hrs'
	ELSE 'Movie is 2hrs long' END AS movie_length
FROM specs AS s
INNER JOIN rating AS r
USING(movie_id)
GROUP BY s.length_in_min, movie_length
ORDER BY avg_rating DESC)
GROUP BY movie_length

-- answer: Movies over 2 hrs have a higher average rating





-- SELECT s.length_in_min, AVG(r.imdb_rating) AS avg_rating,	
-- 	CASE WHEN s.length_in_min > 120 THEN 'Movie is longer than 2hrs'
-- 	WHEN s.length_in_min < 120 THEN 'Movie is shorter than 2hrs'
-- 	ELSE 'Movie is 2hrs long' END AS movie_length
-- FROM specs AS s
-- INNER JOIN rating AS r
-- USING(movie_id)
-- GROUP BY s.length_in_min, movie_length
-- ORDER BY avg_rating DESC