SELECT *
FROM specs
WHERE domestic_distributor_id = 86144


Question 6


SELECT d.company_name, r.imdb_rating, COUNT(s.film_title) AS movie_num
FROM distributors AS d
INNER JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
INNER JOIN rating AS r
ON s.movie_id= r.movie_id 
WHERE d.headquarters NOT ILIKE '%CA'
GROUP BY r.imdb_rating, d.company_name	
ORDER BY r.imdb_rating DESC








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
