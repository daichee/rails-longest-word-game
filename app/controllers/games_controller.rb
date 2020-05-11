class GamesController < ApplicationController
  # def initialize
  #   @@time = Time.now.to_i
  #   @@letters = []
  # end

  def new
    @letters = []
    10.times { @letters << (65 + rand(26)).chr }
    @start_time = Time.now
  end

  def score
    start_time = DateTime.strptime(params[:start], '%Y-%m-%d %H:%M:%S %z')
    end_time = Time.now

    word = params[:word]
    require 'open-uri'
    require 'json'
    url = 'https://wagon-dictionary.herokuapp.com/'
    url_with_word = url + word
    response = open(url_with_word).read
    result = JSON.parse(response)

    not_in_grid = false
    word.scan(/\w/).each { |char| not_in_grid = true unless params[:letters].include? char.upcase }

    if not_in_grid
      @return = 'The word can’t be built out of the original grid'
    elsif !result["found"]
      @return = 'The word is valid according to the grid, but is not a valid English word'
    else
      @return = 'Validated!'
      @score = result["length"] / Math.log(end_time - start_time)
    end
  end
end
