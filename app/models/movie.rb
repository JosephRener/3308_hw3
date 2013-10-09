class Movie < ActiveRecord::Base
  def self.all_ratings
    self.select('rating').group('rating').map { |m| m.rating }
  end
end
