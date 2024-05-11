USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name,
	   table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

/* 
Observation:

	director_mapping = 3867
	genre = 14662
	movie = 7277
	names = 27318
	ratings = 8230
	role_mapping = 16011
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
		SUM(CASE 
				WHEN id IS NULL THEN 1
                ELSE 0 
			END) AS null_id,
		SUM(CASE 
				WHEN title IS NULL THEN 1
                ELSE 0 
			END) AS null_title,
		SUM(CASE 
				WHEN year IS NULL THEN 1
                ELSE 0 
			END) AS null_year,
		SUM(CASE 
				WHEN date_published IS NULL THEN 1
                ELSE 0 
			END) AS null_date_published,
		SUM(CASE 
				WHEN duration IS NULL THEN 1
                ELSE 0 
			END) AS null_duration,
		SUM(CASE 
				WHEN country IS NULL THEN 1
                ELSE 0 
			END) AS null_country,
		SUM(CASE 
				WHEN worlwide_gross_income IS NULL THEN 1
                ELSE 0 
			END) AS null_worlwide_gross_income,
		SUM(CASE 
				WHEN languages IS NULL THEN 1
                ELSE 0 
			END) AS null_languages,
		SUM(CASE 
				WHEN production_company IS NULL THEN 1
                ELSE 0 
			END) AS null_production_company
FROM movie;

/*
Observation: 

	There are total four columns of the movie table has null values.

	country = 20
	worlwide_gross_income = 3724
	languages = 194
	production_company = 528

	Column 'worlwide_gross_income' has highest null values which is 46% of the data and column 'country' has lowest which is 0.25% of the data.
*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

# The total number of movies released each year

SELECT year,
	   COUNT(id) AS movie_count
FROM movie
GROUP BY year;

# The month wise trend

SELECT MONTH(date_published) AS month_num,
	   COUNT(id) AS movie_count
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*
Observation: 

	In 2017, highest number of movies were released which is 3052.
 	In 2019, lowest number of movies were released which is 2001.
	In the month of March the highest number of movies were released which is 824.
	In the month of December the lowest number of movies were released which is 438.
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT Count(DISTINCT id) AS movie_count
FROM movie
WHERE (country LIKE '%INDIA%' OR country LIKE '%USA%') AND year = 2019;

/*
Observation: 

	Total 1059 movies were produced in 2019 by USA or India.
*/	

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre)
FROM genre;

/*
Observation:

	There are total 13 unique genres are present in the data set.
    
	Drama
	Fantasy
	Thriller
	Comedy
	Horror
	Family
	Romance
	Adventure
	Action
	Sci-Fi
	Crime
	Mystery
	Others
*/
    
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
	   COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

/*
Observation:
	
    'Drama' genre produced the highest number of movies which is 4285.
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH count_genre AS
(
	SELECT 
	movie_id, COUNT(genre) AS genre_count
	FROM genre
	GROUP BY movie_id
	HAVING genre_count=1
)
	SELECT COUNT(movie_id) AS movie_count
	FROM count_genre;

/*
Observation:
	3289 movies belong to only one genre.
*/


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	   ROUND(AVG(duration),2) AS avg_duration
FROM movie m
	 INNER JOIN genre g
     ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;
     
/*
Observation:

	Movies of genre 'Action' have the highest average duration and movies of genre 'Horror' have the lowest average duration.
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH count_genre_rank AS
(
	SELECT genre,
		   COUNT(movie_id) AS movie_count,
		   RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
	GROUP BY genre
)
	SELECT *
    FROM count_genre_rank
    WHERE genre = 'thriller';

/*
Observation:

	3rd is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced with 1484 movie count.
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) as min_avg_rating,
	   MAX(avg_rating) as max_avg_rating,
       MIN(total_votes) as min_total_votes,
       MAX(total_votes) as max_total_votes,
       MIN(median_rating) as min_median_rating,
       MAX(median_rating) as max_median_rating
FROM ratings;

/*
Observation:

	   Minimum avg_rating = 1.0
	   Maximum avg_rating = 10.0
	   Minimum total_votes = 10.0
       Maximum total_votes = 725138
       Minimum median_rating = 1
       Maximum median_rating = 10
*/	

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH avg_rating_movie_rank AS
(
	SELECT title,
		   avg_rating, 
		   DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
	FROM movie m
		 INNER JOIN ratings r
		 ON m.id = r.movie_id
)
	SELECT *
    FROM avg_rating_movie_rank
    WHERE movie_rank <= 10;

/*
Observation:

	Based on average rating,
    2 movies with rank 1 and average rating 10.0
	1 movie with rank 2 and average rating 9.8
	1 movie with rank 3 and average rating 9.7
    2 movies with rank 4 and average rating 9.6
    3 movies with rank 5 and average rating 9.5
    5 movies with rank 6 and average rating 9.4
    2 movies with rank 7 and average rating 9.3
    9 movies with rank 8 and average rating 9.2
	8 movies with rank 9 and average rating 9.1
    7 movies with rank 10 and average rating 9.0
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
	   COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

/*
Observayion:

	Movies with a median rating of 7 is highest based on movie count which is 2257.
    Movies with a median rating of 1 is lowest based on movie count which is 94.
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_count,
       DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie m
	 INNER JOIN ratings r
     ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company;

/*
Observation:
	
    'Dream Warrior Pictures' and 'National Theatre Live' production house has produced the most number of hit movies with movie count 3.
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	   COUNT(id) AS movie_count
FROM genre g
	 INNER JOIN movie m
     ON m.id = g.movie_id
     INNER JOIN ratings r
     ON g.movie_id = r.movie_id
WHERE MONTH(date_published) = 3 AND year = 2017 AND country LIKE '%USA%' AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

/*
Observation:

	Movies of genre 'Drama' have the highest released during March 2017 in the USA had more than 1,000 votes with movie count 24.
	Movies of genre 'Family' have the highest released during March 2017 in the USA had more than 1,000 votes with movie count 1.
*/    

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, 
	   avg_rating, 
       genre
FROM movie m
	 INNER JOIN genre g
     ON m.id = g.movie_id
     INNER JOIN ratings r
     ON g.movie_id = r.movie_id
WHERE title LIKE 'the%' AND avg_rating > 8
ORDER BY avg_rating DESC;

/*
Observation:

	There are 8 movies of each genre that start with the word ‘The’ and which have an average rating > 8.
    Movies of genre 'Drama' are more in numbers and have the highest average rating which is 9.5.
*/    

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(id) AS movie_released_count,
	   median_rating
FROM movie m
	 INNER JOIN ratings r
     ON m.id = r.movie_id
WHERE (date_published BETWEEN '2018-04-01' AND '2019-04-01') AND median_rating = 8
GROUP BY median_rating;

/*
Observation:

	There are 361 movies which are released between 1 April 2018 and 1 April 2019, with median rating of 8.
*/    


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country,
	   SUM(total_votes) AS vote_count
FROM movie m
	 INNER JOIN ratings r
     ON m.id = r.movie_id
WHERE country = 'germany' OR country LIKE 'italy'
GROUP BY country;

/*
Observation:

	Yes, German movies do get more votes than Italian movies.
    German movies got 28745 more votes than Italian movies.
*/   

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE 
				WHEN name IS NULL THEN 1
                ELSE 0 
			END) AS name_nulls,
		SUM(CASE 
				WHEN height IS NULL THEN 1
                ELSE 0 
			END) AS height_nulls,
		SUM(CASE 
				WHEN date_of_birth IS NULL THEN 1
                ELSE 0 
			END) AS date_of_birth_nulls,
		SUM(CASE 
				WHEN known_for_movies IS NULL THEN 1
                ELSE 0 
			END) AS known_for_movies_nulls
FROM names;

/*
Observation: 

	There are total three columns of the movie table has null values.

	height = 17335
	date_of_birth = 13431
	known_for_movies = 15226

	Column 'name' do not have any null value
    Column 'height', 'date_of_birth', 'known_for_movies' has null values more than 50% which is 67%, 52%, 59% respectively.
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:			

WITH top_genre AS
( 
SELECT genre,
	   COUNT(g.movie_id) as movie_count
FROM genre g
	INNER JOIN ratings r
	ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
), 
top_director AS
(
SELECT name as director_name,
	   COUNT(d.movie_id) as movie_count,
	   RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM names n
	 INNER JOIN director_mapping d
	 ON n.id = d.name_id
	 INNER JOIN ratings r
	 ON r.movie_id = d.movie_id
	 INNER JOIN genre g
	 ON g.movie_id = d.movie_id,top_genre
WHERE avg_rating > 8 AND g.genre IN (top_genre.genre)
GROUP BY name
ORDER BY movie_count DESC
)
SELECT director_name, 
	   movie_count
FROM top_director
WHERE director_rank <= 3
LIMIT 3;

/*
Observation:
	James Mangold is at the top in top three directors in the top three genres whose movies have an average rating > 8 with movie count 4.
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name,
	   COUNT(rm.movie_id) AS movie_count
FROM role_mapping rm
	 INNER JOIN names n
	 ON n.id = rm.name_id
	 INNER JOIN ratings r
	 ON r.movie_id = rm.movie_id
WHERE category="actor" AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

/*
Observation:
	Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8 with movie count 8 and 5 respectively.
*/
    
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   SUM(total_votes) AS vote_count,
       DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
	 INNER JOIN ratings r
     ON m.id = r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC
LIMIT 3;

/*
Observation:
	Marvel Studios, Twentieth Century Fox, Warner Bros. are the top three production houses based on the number of votes received by their movies.
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actor_name,
	   SUM(r.total_votes) as total_votes,
	   COUNT(r.movie_id) as movie_count,
	   ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating, 
       RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actor_rank
FROM names n
	 INNER JOIN role_mapping rm
	 ON n.id = rm.name_id
	 INNER JOIN ratings r
	 ON rm.movie_id = r.movie_id
	 INNER JOIN movie m
	 ON m.id = r.movie_id
WHERE rm.category='actor' AND m.country='India'
GROUP BY n.name
HAVING COUNT(r.movie_id) >= 5;

/*
Observation:
	
    Vijay Sethupathi is at the top of the actor list with movies released in India and based on their average ratings which is 8.42.
*/    
    
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.name,
	   SUM(total_votes) AS total_votes,
	   COUNT(m.id) AS movie_count,
	   Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
       RANK() OVER(ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) DESC) AS actress_rank
FROM names n
	INNER JOIN role_mapping rm
	ON n.id = rm.name_id
	INNER JOIN movie m
	ON rm.movie_id = m.id
	INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE rm.category = 'ACTRESS' AND m.languages LIKE '%Hindi%' AND m.country = 'INDIA'
GROUP BY n.name
HAVING COUNT(m.id) >=3
LIMIT 5;

/*
Observation:
	
    Taapsee Pannu is at the top of the actress list with movies released in India and based on their average ratings which is 7.74.
*/    
    


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT title,
	   avg_rating,
	CASE
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		ELSE 'Flop Movies'
	END AS avg_rating_category
FROM movie m
	INNER JOIN genre g
	ON m.id = g.movie_id
	INNER JOIN ratings r
	ON r.movie_id = m.id
WHERE genre='thriller';

/*
Observation:

		19 'Superhit movies' with highest average rating 9.5.
        95 'Hit movies' with highest average rating 8.
        522 'One-time-watch movies' with highest average rating 6.9
        364 'Flop Movies' with highest average rating 4.9
*/		

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
	   ROUND(AVG(duration),2) AS avg_duration,
       SUM(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       ROUND(AVG(AVG(duration)) OVER (ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie m
	 INNER JOIN genre g
     ON m.id = g.movie_id
GROUP BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_three_genre AS
(
	SELECT genre,
		   COUNT(movie_id) AS movie_count
	FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
	top_five_grossing_movies AS
(
	SELECT genre,
		   year,
           title AS movie_name,
           worlwide_gross_income,
           DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
	FROM movie m
		 INNER JOIN genre g
         ON m.id = g.movie_id
    WHERE genre IN (SELECT genre 
					FROM top_three_genre)     
)
	SELECT * 
    FROM top_five_grossing_movies
    WHERE movie_rank <= 5;

/*
Observation:
	
	Shatamanam Bhavati is at the top of the five highest-grossing movies of year 2017 that belong to the 'Drama' genre
    with worlwide_gross_income INR 530500000.
    The Villain is at the top of the five highest-grossing movies of year 2018 that belong to the 'Thriller' genre 
    with worlwide_gross_income INR 1300000000.
	Prescience is at the top of the five highest-grossing movies of year 2019 that belong to the 'Thriller' genre 
    with worlwide_gross_income $ 9956.
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_count,
       ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
	 INNER JOIN ratings r
     ON m.id = r.movie_id
WHERE median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;
       
/*
Observation:

	'Star Cinema' and 'Twentieth Century Fox' are the top two production houses that have produced the highest number of hits 
    among multilingual movies.
*/    

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT name AS actress_name,
	   SUM(total_votes) AS total_votes,
       COUNT(id) AS movie_count,
       ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
       RANK() OVER(ORDER BY COUNT(id) DESC) AS actress_rank
FROM names n
	 INNER JOIN role_mapping rm
	 ON n.id = rm.name_id
     INNER JOIN ratings r
     ON r.movie_id = rm.movie_id
     INNER JOIN genre g
     ON rm.movie_id = g.movie_id
WHERE category = 'actress' AND avg_rating >= 8 AND genre='drama'
GROUP BY name
LIMIT 3;

/*
Observation:

	'Parvathy Thiruvothu', 'Susan Brown', 'Amanda Lawrence' are the top 3 actresses based on number of Super Hit movies in drama genre.
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH date_summary AS
(
	SELECT name_id,
		   name,
           d.movie_id,
           duration,
           avg_rating,
           total_votes,
           date_published,
           LEAD(date_published,1) OVER(PARTITION BY name_id ORDER BY date_published, d.movie_id) AS next_date_published
	FROM director_mapping d
		 INNER JOIN names n
         ON d.name_id = n.id
         INNER JOIN movie m
         ON m.id = d.movie_id
         INNER JOIN ratings r
         ON m.id = r.movie_id
 ),
	top_director AS
 (   
	SELECT *,
		   DATEDIFF(next_date_published,date_published) AS date_difference
    FROM date_summary
)
	SELECT name_id AS director_id,
		   name AS director_name,
		   COUNT(movie_id) AS number_of_movies,
		   ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
           ROUND(AVG(avg_rating),2) AS avg_rating,
           SUM(total_votes) AS total_votes,
           MIN(avg_rating) AS min_rating,
           MAX(avg_rating) AS max_rating,
           SUM(duration) AS total_duration
	FROM top_director
    GROUP BY director_id
    ORDER BY number_of_movies DESC
    LIMIT 9;
    
/*
Observation:

	'Andrew Jones' and 'A.L. Vijay' are at the top of top 9 directors based on number of movie with movie count 5
*/


