require 'yaml'

class Hangman
  attr_accessor :lives, :selected_words, :incorrect_letters, :secret_word, :board 

  def initialize
    @lives = 6
    @incorrect_letters = []
    @secret_word = words_list.sample
    @board = setup_board
  end

  def words_list
    @selected_words = []
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
    # If any of the letters in secret_word match then update board at the location of the matching letters to reveal the guessed word.
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
    file_name = "#{gets.chomp}.yml"
    
    begin
      File.write("data/saved_games/#{file_name}", YAML.dump(game_data))
      puts 'Game saved successfully!'
    rescue => e
      puts "Error saving game: #{e.message}"
    end
  end

  def load_game
  # open directory 'saved_games' and list the games saved
    begin
      Dir.foreach('data/saved_games/') do |file|
        # Skip hidden files
        next if file.start_with?('.')
          puts file
      end
    rescue SystemCallError => e
      puts "Error accessing directory: #{e.message}"
    end
  # ask user for filename game
    print "Please, enter a saved game name to load: "
    filename = "data/saved_games/#{gets.chomp}.yml"
    begin
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
    rescue StandardError => e
      puts "Error loading game: #{e.message}"
    end
      play_game
  end

  def play_game
    puts "\n\nWelcome to Hangman!"
    # puts "The secret word is: #{@secret_word}" # For debugging
    
    until won? || lost?
      # print number of lives
      puts "\n\nYou have #{lives} lives left."
      
      # print the board state
      puts board_state
     
      # user input: (p)lay or (s)ave the game
      print "\nYou wanna (p)lay, (s)ave the game or e(x)it? "
      user_input = gets.chomp

      case user_input
      when 'p'
        guess = make_guess
        update_board(guess)
      when 's'
        # serializing and save game
        save_game
      when 'x'
        puts 'Goodbye!'
        break
      else
        puts 'Invalid option, please try again.'     
      end
    end
    
    if won?
      puts "\nCongrats, you won!"
    elsif lost?
      puts "\nSorry, you lost... The secret word was: #{secret_word}"
    else
      exit
    end
  end
end

game = Hangman.new

loop do
  puts '1. New Game'
  puts '2. Load Game'
  puts '3. Exit Game'
  choice = gets.chomp.to_i

  case choice
  when 1
    game.play_game
  when 2
    game.load_game
  when 3
    break
  else
    puts 'Invalid choice, please try again.'
  end
end

#   # Main game loop starts here
#   while game.playing?
#     # ... game logic ...
#   end
# end
