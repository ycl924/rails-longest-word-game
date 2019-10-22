require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = Array.new(10) { [*"A".."Z"].sample }
  end

  def clean
    session.clear
    redirect_to action: "new"
  end

  def valid_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    parsed_url = open(url).read
    word_hash = JSON.parse(parsed_url)
    word_hash["found"] ? true : false
  end

  def score
    @score = 0
    session[:user_score] ||= 0
    attempt = params[:attempt]
    @attempt = attempt
    grid = params[:grid]
    result_hash = show_result(grid, attempt)
    @result = result_hash[:result]
    @score = result_hash[:score]
    session[:user_score] += @score
  end

  def show_result(grid, string)
    return_hash = {}
    if !valid_word?(string)
      result = "Sorry, invalid word."
      score = 0
    elsif valid_word?(string) && !matching_word?(string, grid)
      result = "Sorry, that word is valid but it didn't follow the rules."
      score = 0
    elsif valid_word?(string) && matching_word?(string, grid)
      result = "Congratulations! #{@attempt} is a valid word."
      score = (string.length) * 10
    end
    return_hash = {result: result, score: score}
    return return_hash
  end

  def valid_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    parsed_url = open(url).read
    word_hash = JSON.parse(parsed_url)
    word_hash["found"] ? true : false
  end

  def matching_word?(attempt, grid)
    attempt.upcase.split('').all? { |l| attempt.upcase.split('').count(l) <= grid.count(l) && grid.include?(l) }
  end


end
