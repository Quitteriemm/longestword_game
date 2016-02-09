class StartgamesController < ApplicationController

require 'open-uri'
require 'json'
  def game
    @grid_generate = Array.new(10) { ('A'..'Z').to_a[rand(26)] }
    # @start_time = params[:start_time]
    # @end_time = params[:end_time]
  end

  def included?(guess, grid)
    the_grid = grid.clone
    guess.chars.each do |letter|
      the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
    end
    grid.size == guess.size + the_grid.size
  end

  def score
    @query = params[:query]
    @grid_generate = params[:grid_generate].split(' ')
    @score = 0
    @end_time = Time.now.strftime("%FT%T%:z")
    # @time = Time.parse(params[:start_time]) - Time.parse(params[:end_time])
    @time = Time.parse(@end_time) - Time.parse(params[:start_time])

    @response = "http://api.wordreference.com/0.8/80143/json/enfr/#{@query}"
    @json = JSON.parse(open(@response).read)
    @translation = @json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless @json["Error"]

    if @translation
      if included?(@query.upcase, @grid_generate)
        @score = @grid_generate.size - @time
        @message = "well done"
      else
        @score = 0
        @message = "not in the grid"
      end
    else
      @score = 0
      @message = "not an english word"
    end
  end
end


#  initial


# def included?(guess, grid)
#   the_grid = @grid_generate.clone
#   guess.chars.each do |letter|
#     the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
#   end
#   grid.size == guess.size + the_grid.size
# end

# def compute_score(attempt, time_taken)
#   (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
# end

# def run_game(attempt, grid, start_time, end_time)
#   result = { time: end_time - start_time }

#   result[:translation] = get_translation(attempt)
#   result[:score], result[:message] = score_and_message(
#     attempt, result[:translation], grid, result[:time])

#   result
# end

# def score_and_message(attempt, translation, grid, time)
#   if translation
#     if included?(attempt.upcase, grid)
#       score = compute_score(attempt, time)
#       [score, "well done"]
#     else
#       [0, "not in the grid"]
#     end
#   else
#     [0, "not an english word"]
#   end
# end


# def get_translation(word)
#   response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
#   json = JSON.parse(response.read.to_s)
#   json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
# end
