ratings_data = load 'movies/u.data' using PigStorage('\t') as (userID:int,movieID:int,rating:int,ratingTime:int);
dump ratings_data;

movies_data = load 'movies/uu.item’' using PigStorage('|') as (movieID:int,movieTitle:chararray, releaseDate:chararray, imdbLink:chararray);
dump movies_data;

movies_data_f = FOREACH movies_data GENERATE movieID, movieTitle,ToUnixTime(ToDate(releaseDate, 'dd-MMM-yyyy')) AS releaseTime;
dump movies_data_f;

ratings_by_movie = Group ratings_data By movieID;
dump ratings_by_movie;

ratings_avg_b = FOREACH ratings_by_movie GENERATE group as movieID,AVG(ratings_data.rating) AS avgRating, COUNT(ratings_data.rating) AS numRatings;

one_star_movies = FILTER ratings_avg_b By avgRating <= 1.0;

one_star_data = JOIN one_star_movies By movieID, movies_data_f By movieID;
dump one_star_data ;

one_star_data_f = FOREACH one_star_data GENERATE movies_data_f::movieTitle, one_star_movies::avgRating, one_star_movies::numRatings;

one_star_data_sorted = ORDER one_star_data_f  BY numRatings DESC;

popular_bad_movie = LIMIT one_star_data_sorted 1;
dump popular_bad_movie;
