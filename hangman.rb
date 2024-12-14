puts 'Welcome to Hangman game!'

def load_dictionary
  selected_words = []  # Define selected_words within the method
    File.readlines('data/google-10000-english-no-swears.txt').each do |word|
      selected_words << word.strip if word.size.between?(5, 12)
    end
  selected_words  # Return the selected words
end

selected_words = load_dictionary  # Capture returned value
secret_word = selected_words.sample
puts "The secret word chosen is: #{secret_word}" # For debugging

board = ['_'] * secret_word.size
puts board.join(' ')

lives = 6

while lives > 0 && board.include?('_')
  puts "You have #{lives} lives left. Please, guess a letter:"
  guess = gets.chomp
  puts "Your guess was: #{guess}"

  if secret_word.include?(guess)
    # If any of the letters in secret_word match then update board
    # at the location of the matching letters to reveal the guessed word.
    secret_word.chars.each_with_index do |char, index|
      if char == guess
        board[index] = char
      end
    end
  else
    lives -= 1
    puts "The word does not include: #{guess}"
  end

  puts board.join(' ')
end

if board.join('') == secret_word
  puts "Congrats, you win!"
else
  puts "Sorry, you lose... The secret word is: #{secret_word}"
end
