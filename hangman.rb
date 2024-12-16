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
    print "\nPlease, guess a letter: "
    gets.chomp[0]
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

  def play
    puts 'Welcome to Hangman!'
    # puts "The secret word is: #{@secret_word}" # For debugging

    # Ask for user action: (p)lay a new game or (l)oad a saved game
    while !lost? && !won?
      # print number of lives
      puts "\nYou have #{lives} lives left."
      # print the board state
      puts board_state
      # receive a guess
      guess = make_guess
      # update the board
      update_board(guess)
    end
    
    if won?
      puts "Congrats, you won!"
    else
      puts "Sorry, you lost... The secret word was: #{secret_word}"
    end
  end
end

game = Hangman.new
game.play
