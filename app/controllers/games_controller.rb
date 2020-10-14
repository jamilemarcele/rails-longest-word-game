require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    word = params[:word].upcase.split(//)
    letter_array = params[:letter_array].split(' ')
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"

    #API Call
    dictionary = open(url).read
    english_word = JSON.parse(dictionary)

    valid_word = word.all? do |letter|
      letter_array.include?(letter)
    end

    @score = 0
    if valid_word == false
      @answer = "Sorry but <strong>#{params[:word]}</strong> can't be built out of #{params[:letter_array]}".html_safe
    elsif valid_word && english_word['found'] == false
      @answer = "Sorry but <strong>#{params[:word]}</strong> is not a valid English word".html_safe
    else
      @answer = "<strong>Congrats!</strong> #{params[:word]} is a valid English word!".html_safe
      @score = params[:word].length
    end
  end
end


# => <ActionController::Parameters {"authenticity_token"=>"HuEmyX6XR0z5nqMhwsyEyr8GAURQGfqoJ2CC7iiPA3F3120qEEOeQ2rmQwbNxCi81INimgSzBSwE40BVe1g3GQ==", "letter_array"=>"N H X V I E R Z F O", "word"=>"hello", "controller"=>"games", "action"=>"score"} permitted: false>
# => {"found"=>false, "word"=>"bck", "error"=>"word not found"}
