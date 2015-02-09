# February 9, 2015
# cosi 105b, prof. Pito Salas
# Aviv Glick
#
# (PA) Movies Part 1 / Movies Part 2
#
# This class arranges information about rated movies and extracts it from a database, based on the criteria:
# User id, movie id, and rating.


class Movies1

  @@USER_ID = 0 #class variables
  @@MOVIE_ID = 1
  @@RATING = 2
  @@TIME_STAMP = 3

	attr_accessor :data, :ratedMoviesHash, :allUsersHash

	def initialize(fileName)
		@data = load_data(fileName)
    @ratedMoviesHash = hashMovies()
    @allUsersHash = hashUsers()
	end

  # reads the data from the database and stores it as nested array of strings, of four elements in each array.
	def load_data(fileName)
    set = open(fileName, 'r')
    data = []
    set.each_line do |line|
      categories = line.split(' ')
      data.push(categories)
    end
    return data
  end
  
  # returns the popularity of a given movie, whose value is (a + 2^r) - 1, where: 
  # a = the movie's average rating 
  # r = the ratio of the number of users who have rated the movie to the total number of users (always between 0 - 1).
  # Thus, the popularity scale is 1 to 5, regardless of the number of users.
  def popularity(movieId)
    return "ERROR: No such movie ID in the database" if @ratedMoviesHash["#{movieId}"].nil?
    return average(@ratedMoviesHash["#{movieId}"]) + (2 ** (@ratedMoviesHash["#{movieId}"].length / (@allUsersHash.keys.length).to_f)) - 1
	end

  # returns a list of popular movies, ordered by popularity in a decreasing order
	def popularity_list
    averageRatingMoviesHash = {}
    @ratedMoviesHash.each {|movie, ratings| averageRatingMoviesHash[movie] = average(ratings) * (2 ** (@ratedMoviesHash["#{movie}"].length / (@allUsersHash.keys.length).to_f)) - 1}
    ratedMoviesArray = averageRatingMoviesHash.sort_by { |movie, aveRating| -aveRating }
    popularityList = []
    ratedMoviesArray.each {|item| popularityList.push(item[0].to_i)} 
    return popularityList
	end

  # returns a hash from a movie to an array of all its ratings {movie} => [rating1, rating2, ...]
  def hashMovies
    ratedMoviesHash = {}
    @data.each do |item|
      if !ratedMoviesHash.has_key?(item[@@MOVIE_ID])
        ratedMoviesHash[item[@@MOVIE_ID]] = []
      end
      ratedMoviesHash[item[@@MOVIE_ID]].push(item[@@RATING])
    end
    return ratedMoviesHash
  end

  # creates a nested hash of all users {user1 => {m1 => r1, m2 => r2, ...}, user2 =>....}
  def hashUsers
    @allUsersHash = {}
    @data.each do |item| 
      if !@allUsersHash.has_key?(item[@@USER_ID])
        @allUsersHash[item[@@USER_ID]] = {}
      end
      @allUsersHash[item[@@USER_ID]][item[@@MOVIE_ID]] = item[@@RATING]
    end
    return @allUsersHash
  end

  # averages the rating of a movie from an array of values of ratings
  def average(ratings)
    ratings.inject(0.0) { |sum, el| sum + el.to_f } / ratings.size
  end

  # returns a number that indicates similarities in movie preference
  # between user1 and user2 (by user_id parameters).
  # Highest similarity = 4. Lowest similarity = 0.
  def similarity(user1, user2)
    user1Hash = @allUsersHash[user1]
    user2Hash = @allUsersHash[user2]
    return "ERROR: USER ID #{user1} is not in the database" if user1Hash.empty?
    return "ERROR: USER ID #{user2} is not in the database" if user2Hash.empty?
    find_similarity(user1Hash, user2Hash)
  end

  # returns the similary value of two users, based on the average similairy value between
  # any two movies both users have seen and the number of movies they both rated. If the differences between the 
  # ratings are 4, 3, 2, 1, 0, the added value for each is 0, 1, 2, 3, 4 respectively, so the higher the value, 
  # the greater the similarity.
  def find_similarity(user1Hash, user2Hash)
    similarityValue = -1 # If no common movies watched, return -1
    countMovies = 0.0
    user1Hash.each do |movie, rating|
      if user2Hash.has_key?(movie)
        countMovies += 1
        similarityValue += 4 - (rating.to_i - user2Hash[movie].to_i).abs 
      end
    end
    similarityValue != -1 ? (similarityValue + 1) / countMovies : similarityValue
  end

  # returns a list of users whose tastes are most similar to the taste of user u
  def most_similar(u)
    uHash = @allUsersHash["#{u}"]
    return nil if uHash == nil
    similarUserHash = {}
    @allUsersHash.each { |userId, u2Hash| similarUserHash[userId.to_i] = find_similarity(uHash, u2Hash) if u != userId.to_i }
    return similarUserHash.sort_by { |user, similarityValue| -similarityValue }
  end
end



