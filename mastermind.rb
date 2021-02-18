require 'pry'
class CodeBreaker
  # user selects to break the code will create random code and play game
  def initialize
    @code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
    p @code
  end

  def check_code(guess)
    guess_test = @code.join.split('')
    guess_result = guess.reduce([]) do |array, number|
      if guess_test.include? number
        guess_test.delete_at(guess_test.index(number))
        array << 'X'
      end
      array
    end
    guess.each_with_index do |number, index|
      if number.to_i == @code[index]
        guess_result.pop
        guess_result.unshift 'O'
      end
    end
    puts guess_result.join(', ')
  end
end

class CodeMaker
  # Sets code to be broken
end

def start_game
  game = CodeBreaker.new

  p 'enter guess'
  result = game.check_code(gets.chomp.split(''))

end

start_game
