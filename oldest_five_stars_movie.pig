ratings_data = load 'movies/u.data' using PigStorage('\t') as (userID:int,movieID:int,rating:int,ratingTime:int);
dump ratings_data;

movies_data = load 'movies/uu.item’' using PigStorage('|') as (movieID:int,movieTitle:chararray, releaseDate:chararray, imdbLink:chararray);
dump movies_data;

movies_data_f = FOREACH movies_data GENERATE movieID, movieTitle,ToUnixTime(ToDate(releaseDate, 'dd-MMM-yyyy')) AS releaseTime;
dump movies_data_f;

ratings_by_movie = Group ratings_data By movieID;
dump ratings_by_movie;

ratings_avg = FOREACH ratings_by_movie GENERATE group as movieID,AVG(ratings_data.rating) AS avgRating;
dump ratings_avg;

five_star_movies = FILTER ratings_avg By avgRating > 4.0;
dump five_star_movies;

five_star_data = JOIN five_star_movies By movieID, movies_data_f By movieID;
dump five_star_data ;

five_star_ordered = ORDER five_star_data By releaseTime;
dump five_star_ordered ;

oldest_movie_rated_5stars = LIMIT five_star_ordered 1 ;
dump  oldest_movie_rated_5stars ;
