require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word].downcase
    @letters = params[:letters].chars
    included = @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    # The word can’t be built out of the original grid
    if included == false
      # -> fail if a letter in @word is not included in @letters
      @result = "Sorry, but #{@word.upcase} cannot be made from #{@letters.join(', ').upcase} ❌"
    else
      # The word is valid according to the grid, but is not a valid English word
      url = "https://dictionary.lewagon.com/#{@word}"
      api_response = URI.open(url).read
      word_data = JSON.parse(api_response)
      if word_data["found"] == true
        @result = "Congratulations! #{@word.upcase} is a valid English word! ✅"
      else
        @result = "Sorry, but #{@word.upcase} is not a valid English word... ❌"
      # The word is valid according to the grid and is an English word
      end
    end
  end
end
