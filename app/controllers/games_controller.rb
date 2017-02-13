class GamesController < ApplicationController

  def game
    @grid = generate_grid(9)
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    @result = run_game(params[:word], params[:grid].split(''), DateTime.strptime(params[:start_time], '%Y-%m-%d %H:%M:%S %z'), end_time)
    @result[:attempt] = params[:word]
  end



  def generate_grid(grid_size)
    return Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end



  def score_and_message(attempt, translation, grid, time)
    if included?(attempt.upcase, grid)
      if translation
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not a word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def compute_score(attempt, time_taken)
    (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def included?(guess, grid)
    guess.split('').each { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: (end_time - start_time).round }

    result[:translation] = get_translation(attempt)
    result[:score], result[:message] = score_and_message(
      attempt, result[:translation], grid, result[:time])
    return result
  end
end
