## Procedural Version
# puts 'Welcome to Hangman game!'

# def load_dictionary
#   selected_words = []  # Define selected_words within the method
#   begin
#     File.readlines('data/google-10000-english-no-swears.txt').each do |word|
#       selected_words << word.strip if word.strip.size.between?(5, 12)
#     end
#   rescue Errno::ENOENT
#     puts 'Error: Dictionary file not found.'
#     exit 1
#   end
#   selected_words  # Return the selected words
# end

# # words_list = load_dictionary  # Capture returned value
# secret_word = load_dictionary.sample
# puts "The secret word chosen is: #{secret_word}" # For debugging

# incorrect_letters = []
# board = ['_'] * secret_word.size
# puts board.join(' ')

# lives = 6

# while lives > 0 && board.include?('_')
#   print "\nYou have #{lives} lives left. Please, guess a letter: "
#   guess = gets.chomp 
#   # puts "Your guess was: #{guess}"

#   if secret_word.include?(guess)
#     # If any of the letters in secret_word match then update board
#     # at the location of the matching letters to reveal the guessed word.
#     secret_word.chars.each_with_index do |char, index|
#       if char.downcase == guess.downcase
#         board[index] = char
#       end
#     end
#   else
#     lives -= 1
#     incorrect_letters << guess
#     puts "The word did not include: #{guess}"
#     puts "Incorrect letters chosen: #{incorrect_letters}"
#   end

#   puts board.join(' ')
# end

# if board.join('') == secret_word
#   puts "Congrats, you won!"
# else
#   puts "Sorry, you lose... The secret word was: #{secret_word}"
# end

## Object-Oriented Version

require 'yaml'

class Hangman
  attr_accessor :lives, :selected_words, :incorrect_letters, :secret_word, :board 

  def initialize
    @lives = 6
    @selected_words = []
    @incorrect_letters = []
    @secret_word = words_list.sample
    @board = setup_board
  end

  def words_list
    begin
      File.readlines('data/google-10000-english-no-swears.txt').each do |word|
        selected_words << word.strip if word.strip.size.between?(5, 12)
      end
    rescue Errno::ENOENT
      puts 'Error: Dictionary file not found.'
      exit 1
    end
    selected_words  # Return the selected words
  end

  def setup_board
    ['_'] * secret_word.size
  end

  def board_state
    board.join(' ')
  end

  def make_guess
    print "Please, guess a letter: "
    gets.chomp
  end

  def update_board(guess)
    if secret_word.include?(guess)
    # If any of the letters in secret_word match then update board
    # at the location of the matching letters to reveal the guessed word.
      secret_word.chars.each_with_index do |char, index|
        if char.downcase == guess.downcase
           board[index] = char
        end
      end
    else
      self.lives -= 1
      incorrect_letters << guess
      # puts "The word did not include: #{guess}"
      puts "Incorrect letters chosen: #{incorrect_letters}"
    end
  end

  def won?
    board.join('') == secret_word  
  end

  def lost?
    lives == 0
  end

  # def user_choice
  #   print "\nYou wanna (p)lay or (s)ave the game? "
  #   gets.chomp
  # end

  def save_game
    game_data = {
      lives: @lives,
      secret_word: @secret_word,
      incorrect_letters: @incorrect_letters,
      board: @board
    }

    print "Save game as: "
    filename = "#{gets.chomp}.yml"

    Dir.chdir('data')
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    Dir.chdir('saved_games')

    ## exception handling
    # begin
    #   File.write(filename, YAML.dump(game_data))
    #   puts 'Game saved successfully!'
    # rescue => e
    #   puts "Error saving game: #{e.message}"
    # end

    File.write(filename, YAML.dump(game_data))
    puts 'Game saved successfully!'
  end

  def load_game
  # open directory 'saved_games' and list the games saved
  # ask user for a filename game
    print "Please, enter a saved game name: "
    filename = "#{gets.chomp}.yml"
  
    if File.exist?(filename)
      game_data = YAML.load_file(filename)
      @lives = game_data[:lives]
      @secret_word = game_data[:secret_word]
      @incorrect_letters = game_data[:incorrect_letters]
      @board = game_data[:board]
      puts "Game loaded successfully!"
    else
      puts "No saved game found. Starting a new game..."
    end
  end

  def play
    puts 'Welcome to Hangman!'
    # puts "The secret word is: #{@secret_word}" # For debugging
    until won? || lost?
      # print number of lives
      puts "\n\nYou have #{lives} lives left."
      # print the board state
      puts board_state
      # user input: (p)lay or (s)ave the game
      print "\nYou wanna (p)lay or (s)ave the game? "
      user_input = gets.chomp

      if user_input == 'p' 
        guess = make_guess
      else
      # serializing saved game
        save_game
      # end_game method
      end

      # update the board
      update_board(guess)
    end
    
    if won?
      puts "\nCongrats, you won!"
    else
      puts "\nSorry, you lost... The secret word was: #{secret_word}"
    end
  end
end

game = Hangman.new
game.play
