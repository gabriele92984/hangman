puts 'Welcome to Hangman game!'

dictionary_path = 'data/google-10000-english-no-swears.txt'

def load_dictionary(dictionary)
  selected_words = []  # Define selected_words within the method
  begin
    File.readlines(dictionary).each do |word|
      selected_words << word.strip if word.size.between?(5, 12)
    end
  rescue Errno::ENOENT
    puts "Error: Dictionary file not found."
    exit 1  # Exit the program if the file is not found
  end
  selected_words  # Return the selected words
end

selected_words = load_dictionary(dictionary_path)  # Capture returned value
secret_word = selected_words.sample

puts "The secret word has been chosen."
@