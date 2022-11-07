require 'open-uri'
require 'json'

class GamesController < ApplicationController


  def score
    @word = word(params[:word])
    @message = verify_word(params[:word], params[:letters].split)
    @end_time = Time.now
    @results = { time: @end_time - Time.parse(params[:start_time]) }

  end

  def new
    @letters = generated_letters(10)
  end

  def generated_letters(number)
    Array.new(number) { ('A'..'Z').to_a.sample }
  end

  def word(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    parse = JSON.parse(response.read)
    parse['found']
  end

  def included?(guess, generated_letters)
    guess.chars.all?{ |letter| guess.count(letter) <= generated_letters.count(letter) }
  end

  def verify_word(guess, generated_letters)
    if included?(guess.upcase, generated_letters)
      if word(guess)
        'Well done! You got a Word :)'
      else
        'Not a word'
      end
    else
      'Not on the list of letters!'
    end
  end

end
