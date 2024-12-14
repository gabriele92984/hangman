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

puts "The secret word chosen: #{secret_word}"

puts 'Please, guess a letter:'
guess = gets.chomp

puts "Your guess was: #{guess}"