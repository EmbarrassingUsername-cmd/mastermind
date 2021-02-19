# frozen_string_literal: true

require 'pry'
require 'set'
# contains common code bewtween Code Make and Breaker
module Code
  attr_reader :code

  def check_code(guess, code = @code)
    guess_test = code.split('')
    guess_result = guess.split('').each_with_object([]) do |number, array|
      if guess_test.include? number
        guess_test.delete_at(guess_test.index(number))
        array << 'X'
      end
      array
    end
    guess.split('').each_with_index do |number, index|
      if number.to_i == code.split('')[index].to_i
        guess_result.pop
        guess_result.unshift 'O'
      end
    end
    guess_result
  end

  def choices
    return '1122' if @guesses.zero?

    @possible_codes.sample
  end
end

# user selects to break the code will create random code and play game
class CodeBreaker
  attr_reader :code

  include Code
  def initialize
    super
    @code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)].join
  end
end

# user selects to make the code computer solves
class CodeMaker
  include Code

  def initialize
    @all_codes = [*1..6].product(*[[*1..6]] * 3).map(&:join)
    @all_scores = Hash.new { |h, k| h[k] = {} }
    @all_codes.product(@all_codes).each do |guess, answer|
      @all_scores[guess][answer] = check_code(guess, answer)
    end
    @all_codes.to_set
  end

  def solve(code)
    @guesses = 0
    @code = code
    @possible_codes = @all_codes.clone
    @possible_scores = @all_scores.clone
    until @guesses == 10
      puts 'computers guess, guess number and pin response'
      p computer_guess = choices
      p @guesses += 1
      print result_array = check_code(computer_guess)
      puts "\n"
      break if result_array == %w[O O O O]

      @possible_codes.keep_if do |test_case|
        @possible_scores[computer_guess][test_case] == result_array
      end
      p @possible_codes
    end
  end
end

def start_game_breaker
  game = CodeBreaker.new
  result = []
  9.downto(0) do |i|
    p 'Enter guess'
    result = game.check_code(confirm_valid(gets.chomp))
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
  until entry.length == 4 && entry.split('').all? { |i| i.to_i.between?(1, 6) }
    puts 'Please enter a valid guess containing only 4 numbers 1 to 6'
    entry = gets.chomp
  end
  entry
end

def start_game_maker
  puts 'Please wait while the game initialises'
  test_code = CodeMaker.new
  play_game_maker(test_code)
end

def play_game_maker(test_code)
  try_again = ''
  until try_again == 'n'
    puts 'please enter code'
    test_code.solve confirm_valid(gets.chomp)
    puts 'type n to give up'
    try_again = gets.chomp.downcase
  end
end

def start_game
  choice = gets.chomp until %w[1 2].include?(choice)
  start_game_breaker if choice == '1'
  start_game_maker if choice == '2'
end

puts 'Would you like to solve or create 1 for solve 2 to create'
start_game
