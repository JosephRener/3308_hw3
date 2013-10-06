class Movie < ActiveRecord::Base
  def self.all_ratings
    self.group('rating').map { |m| m.rating }
  end
end
