require 'open-uri'
require 'json'

class GamesController < ApplicationController

  @score = 0

  def new
    $letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(attempt, grid)
    @word.chars.all? { |letter| @word.count(letter) <= $letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def add_score
    @score = 0
    @score += @word.length
  end

  def score
    @word = params[:word]
    if included?(@word, $letters) and english_word?(@word)
      @answer = "Il y a bien un mot qui correspond aux lettres et qui est en anglais !"
      add_score
    elsif included?(@word, $letters)
      @answer = "Il y a bien un mot qui correspond aux lettres mais il n'est pas en anglais !"
    else @answer = "Le mot entré n'est pas valide !"
    end
  end
end
