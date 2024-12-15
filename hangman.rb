# Procedural Version
puts 'Welcome to Hangman game!'

def load_dictionary
  selected_words = []  # Define selected_words within the method
  begin
    File.readlines('data/google-10000-english-no-swears.txt').each do |word|
      selected_words << word.strip if word.size.between?(5, 12)
    end
  rescue Errno::ENOENT
    puts 'Error: Dictionary file not found.'
    exit 1
  selected_words  # Return the selected words
  end
end

# words_list = load_dictionary  # Capture returned value
secret_word = load_dictionary.sample
puts "The secret word chosen is: #{secret_word}" # For debugging

incorrect_letters = []
board = ['_'] * secret_word.size
puts board.join(' ')

lives = 6

while lives > 0 && board.include?('_')
  print "\nYou have #{lives} lives left. Please, guess a letter: "
  guess = gets.chomp 
  # puts "Your guess was: #{guess}"

  if secret_word.include?(guess)
    # If any of the letters in secret_word match then update board
    # at the location of the matching letters to reveal the guessed word.
    secret_word.chars.each_with_index do |char, index|
      if char.downcase == guess.downcase
        board[index] = char
      end
    end
  else
    lives -= 1
    incorrect_letters << guess
    puts "The word did not include: #{guess}"
    puts "Incorrect letters chosen: #{incorrect_letters}"
  end

  puts board.join(' ')
end

if board.join('') == secret_word
  puts "Congrats, you won!"
else
  puts "Sorry, you lose... The secret word was: #{secret_word}"
end

# Object-Oriented Version

