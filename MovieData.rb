# February 9, 2015
# cosi 105b, prof. Pito Salas
# Author: Aviv Glick
#
# (PA) Movies Part 2
#
# This class predicts what rating a user would give to a movie, then run some statistical tests to determine how 
# accurate the predictions are. It requires the class Movies1 and MovieTest to create objects that can run the classes' 
# methods.

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
    @testSet = Movies1.new(testSet) if testSet != nil #creating a testSet object is optional
    @resaults = Struct.new(:userId, :movieId, :rating, :prediction) #creating a Struct object to contain an item with info for statistical analysis
  end

  # returns the rating user u gave to movie m in the Training set, and 0 if u did not rate m
  def rating(u, m)
    return @trainingSet.allUsersHash["#{u}"]["#{m}"].to_i if @trainingSet.allUsersHash["#{u}"]["#{m}"] != nil
    return 0
  end

  # returns array of movies that user u has watched. Use the training set if none was passed
  def movies(u, set=@trainingSet)
    set.allUsersHash["#{u}"].keys if set.allUsersHash["#{u}"] != nil
  end

  # returns the array of users that have seen movie m. Use the training set if none was passed
  def viewers(m, set=@trainingSet)
    (set.data.select {|item| item[@MOVIE_ID].to_i == m}).collect {|item| item[@USER_ID].to_i}
  end

  # returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
  def predict(u, m)
    if @testSet != nil
      aveUserRating = @testSet.average(@testSet.allUsersHash["#{u}"].values) #returns the average rating u gave all movies
      popularity = @testSet.popularity(m)
      popularity + aveUserRating*0.01
    end
  end


  # runs the predict(u, m) method on the first k ratings in the Test set, and
  # returns a MovieTest object containing the results. (Parameter k is optional, and if omitted, all of the tests will run.)
  def run_test(k=nil)
    k ||= @testSet.data.length
    arr = (@testSet.data[0..k-1]).collect do |item|
      @resaults.new(item[@USER_ID].to_i, item[@MOVIE_ID].to_i, item[@RATING].to_i, predict(item[@USER_ID].to_i, item[@MOVIE_ID].to_i))
    end 
    MovieTest.new(arr)  
  end
end



################----HERE ENDS THE CLASS MovieDATA----################



#puts "\nHi! Welcome to the movies database program.\n\nPlease enter the the path for the database file:\n"
movieData = MovieData.new("/Users/avivgl/Dropbox/cosi105b_AvivGlick/movies-2/u1.base", "/Users/avivgl/Dropbox/cosi105b_AvivGlick/movies-2/u1.test") ##{$stdin.gets.chomp}
##puts movieData.rating(1, 10)
##puts movieData.movies(1)
##puts movieData.viewers(647)
##puts movieData.predict(1, 10)
yoo = movieData.run_test()
##puts movieData.movies(1)
##puts movieData.rating(1,272)
##puts yoo.to_a
puts "average prediction error #{yoo.mean}"
puts "root mean square error of the prediction: #{yoo.rms}"
puts "standard deviation of the error: #{yoo.stddev}"

################----HERE ENDS THE CLASS MovieDATA----################


#puts "\nHi! Welcome to the movies database program.\n\nPlease enter the path for the training set file:\n"
#training_set = "#{$stdin.gets.chomp}"
#puts "\nPlease enter the path for the test set file:\n"
#test_set = "#{$stdin.gets.chomp}"
#movieData = MovieData.new(training_set, test_set)
#while true
#  puts "\nPlease enter the number of ratings you wish to test, or press enter to continue: "
#  k = "#{$stdin.gets.chomp}"
#  puts "Calculating... please wait."
#  if k == ""
#    test = movieData.run_test() 
#  else
#    test = movieData.run_test(k.to_i)
#  end
#  puts "average prediction error: #{test.mean}"
#  puts "root mean square error of the prediction: #{test.rms}"
#  puts "standard deviation of the error: #{test.stddev}"
#  puts "\nWould you like to print the predictions in the form [user, movie, rating, predicted rating]? y/n: "
#  k = "#{$stdin.gets.chomp}"
#  if k == "y"
#    puts "#{test.to_a}"
#  end
#  puts "Would you like to exit? y/n"    
#  exit(0) if "#{$stdin.gets.chomp}" == "y"
#end
