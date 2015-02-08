# This object stores a list of all the results of run_text(k), where each resault is a tuple,
# containing the user, rated movie, rating and predicted rating.
# Shall have the following methods:

# 1. mean: returns the average prediction error (which should be close to zero)
# 2. stddev: returns the standard deviation of the error
# 3. rms: returns the root mean square error of the prediction
# 4. to_a: returns an array of the predictions in the form [user, movie, rating, predictedRating].


class MovieTest

  attr_accessor :list

  def initialize(list)
    @list = list
  end

  def mean()
    diff = @list.collect {|item| item[:rating] - item[:prediction]}
    sum(diff) / diff.length
  end

  def stddev()
    prediction_mean = sum(@list.collect {|item| item[:prediction]}) / @list.length
    diffSquare = @list.collect {|item| (item[:prediction] - prediction_mean) ** 2}
    Math.sqrt(sum(diffSquare) / (diffSquare.length - 1))
  end

  def rms()
    diffSquare = @list.collect {|item| (item[:rating] - item[:prediction]) ** 2}
    Math.sqrt(sum(diffSquare) / diffSquare.length)
  end

  def sum(arr)
    arr.inject(0.0) { |sum, el| sum + el.to_f }
  end

  def to_a()
    list.collect {|item| item.values_at 0, 1, 2, 3}
  end

end




