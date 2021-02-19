require 'pry'
# contains common code bewtween Code Make and Breaker
class Code
  attr_reader :code

  def check_code(guess, code = @code)
    guess_test = code.split('')
    guess_result = guess.each_with_object([]) do |number, array|
      if guess_test.include? number
        guess_test.delete_at(guess_test.index(number))
        array << 'X'
      end
      array
    end
    guess.each_with_index do |number, index|
      if number.to_i == code.split('')[index].to_i
        guess_result.pop
        guess_result.unshift 'O'
      end
    end
    guess_result
  end
end

# user selects to break the code will create random code and play game
class CodeBreaker < Code
  attr_reader :code

  def initialize
    super
    @code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)].join
  end
end

# user selects to make the code computer solves
class CodeMaker < Code
  def initialize(code)
    @code = code
    p @set = [*1..6].product(*[[*1..6]] * 3).map(&:join)
    @guesses = 0
  end

  def solve
    until @guesses == 10
      p @guesses += 1
      p computer_guess = @set.sample
      p result_array = check_code(computer_guess.split(''))
      break if result_array == %w[O O O O]

      @set.delete computer_guess
      @set.each do |test_case|
        result = check_code(test_case.split(''), computer_guess)
        @set.delete(test_case) unless result_array == result
      end
      p @set
    end
  end
end

def start_game_breaker
  game = CodeBreaker.new
  result = []
  9.downto(0) do |i|
    p 'Enter guess'
    result = game.check_code(confirm_valid(gets.chomp.split('')))
    puts result.join('')
    break if result == %w[O O O O]

    puts "#{i} attempts remaining"
  end
  if result == %w[O O O O]
    puts 'Congratulations you win'
  else
    puts "The code was #{game.code.join('')} \nNice try!"
  end
end

def confirm_valid(entry)
  until entry.length == 4 && entry.all? { |i| i.to_i.between?(1, 6) }
    puts 'Please enter a valid guess containing only 4 numbers 1 to 6'
    entry = gets.chomp.split('')
  end
  entry
end
start_game_breaker
test_code = CodeMaker.new('5411')
test_code.solve
