
# This class shall have the following methods:
#
# 1. rating(u, m): returns the rating user u gave to movie m in the Training set, and 0 if u did not rate m
# 2. predict(u, m): returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
# 3. movies(u): returns array of movies that user u has watched
# 4. viewers(m): returns the array of users that have seen movie m
# 5. run_test(k): runs the predict(u, m) method on the first k ratings in the Test set, and
#                 returns a MovieTest object containing the results. (Parameter k is optional, and if omitted, all of the tests will run.)

require_relative 'MovieTest'
require_relative 'Movies1'

class MovieData

	attr_accessor :resaults, :trainingSet, :testSet

  def initialize(trainingSet, testSet = nil)
    @USER_ID = 0
    @MOVIE_ID = 1 
    @RATING = 2
    @TIME_STAMP = 3
    @trainingSet = Movies1.new(trainingSet)
    @testSet = Movies1.new(testSet) if testSet != nil
    @resaults = Struct.new(:userId, :movieId, :rating, :prediction)
  end

  def rating(u, m)
    return @trainingSet.allUsersHash["#{u}"]["#{m}"] if @trainingSet.allUsersHash["#{u}"]["#{m}"] != nil
    return 0
  end


  def movies(u, set=@trainingSet)
    set.allUsersHash["#{u}"].keys if set.allUsersHash["#{u}"] != nil
  end


  def viewers(m, set=@trainingSet)
    (set.data.select {|item| item[@MOVIE_ID].to_i == m}).collect {|item| item[@USER_ID].to_i}
  end


  def predict(u, m)
    if @testSet != nil
      aveUserRating = @testSet.average(@testSet.allUsersHash["#{u}"].values) #returns the average rating u gave all movies
      aveMovieRating = @testSet.average(@testSet.ratedMoviesHash["#{m}"])
      popularity = @testSet.popularity(m)
      mostSimilarUserRating = findSimilarUserRating(u, m) 
      mostSimilarUserRating == -1 ? @testSet.average([aveMovieRating, @testSet.average([aveUserRating, popularity])]) : @testSet.average([aveMovieRating, @testSet.average([aveUserRating, mostSimilarUserRating, popularity])])
    else return 0
    end
  end

  def findSimilarUserRating (u, m)
    @testSet.most_similar(u).each do |user|
      mostSimilarUserRating = rating(user[0], m)
      return mostSimilarUserRating if mostSimilarUserRating != 0
    end
    return -1
  end

  def run_test(k=nil)
    k ||= @testSet.data.length
    arr = (@testSet.data[0..k-1]).collect do |item|
      @resaults.new(item[@USER_ID].to_i, item[@MOVIE_ID].to_i, item[@RATING].to_i, predict(item[@USER_ID].to_i, item[@MOVIE_ID].to_i))
    end 
    MovieTest.new(arr)  
  end
end



################----HERE ENDS THE CLASS MovieDATA----################



puts "\nHi! Welcome to the movies database program.\n\nPlease enter the the path for the database file:\n"
movieData = MovieData.new("/Users/avivgl/Dropbox/cosi105b_AvivGlick/movies-2/movies-2/u1.base", "/Users/avivgl/Dropbox/cosi105b_AvivGlick/movies-2/movies-2/u1.test") ##{$stdin.gets.chomp}
#puts movieData.rating(1, 10)
#puts movieData.movies(1)
#puts movieData.viewers(647)
#puts movieData.predict(1, 10)
yoo = movieData.run_test(1000)
#puts movieData.movies(1)
#puts movieData.rating(1,272)
#puts yoo.to_a
puts "average prediction error #{yoo.mean}"
puts "root mean square error of the prediction: #{yoo.rms}"
puts "standard deviation of the error: #{yoo.stddev}"



