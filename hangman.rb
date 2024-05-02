require 'yaml'

class Hangman
  attr_accessor :words

  def initialize
    @words = load_words('google-10000-english-no-swears.txt')
  end
end

class Game
  attr_accessor :word_selected, :indexes_discovered, :num_guesses, :letters_guessed

  def initialize
    @hangman = Hangman.new
    @word_selected = random_word(@hangman.words)
    @indexes_discovered = []
    @num_guesses = 0
    @letters_guessed = []
  end

  def save_game(file_name)
    game_state = {
      word_selected: @word_selected,
      indexes_discovered: @indexes_discovered,
      num_guesses: @num_guesses,
      letters_guessed: @letters_guessed
    }
    File.open(file_name, 'w') { |file| file.write(game_state.to_yaml) }
    puts 'Game saved successfully.'
  end

  def self.load_game(file_name)
    game_state = YAML.load_file(file_name)
    game = Game.new
    game.word_selected = game_state[:word_selected]
    game.indexes_discovered = game_state[:indexes_discovered]
    game.num_guesses = game_state[:num_guesses]
    game.letters_guessed = game_state[:letters_guessed]
    game
  end

  def guess(letter)
    @word_selected.each_char.with_index do |character, index|
      @indexes_discovered << index if character == letter && !@indexes_discovered.include?(index)
    end
    @num_guesses += 1
    @letters_guessed << letter
  end

  def check_win
    if @indexes_discovered.length == @word_selected.length and @num_guesses <= 10
      true
    elsif @num_guesses == 10
      puts 'You used all your 10 guesses. Game is over, try again!'
      false
    end
  end

  def display_word
    @word_selected.each_char.with_index do |character, index|
      if @indexes_discovered.include?(index)
        print character
      else
        print '_ '
      end
    end
    print "\n"
  end

  def menu
    puts "Welcome to Hangman!"
    puts "Would you like to start a new game or open a saved game?"
    puts "Type 'play' to play a game or 'open' to open a saved game."
    
    input = gets.chomp.downcase
    if input == 'play'
      start
    elsif input == 'open'
      open_saved_game
    else
      puts "Invalid input. Please type 'play' or 'open'."
      menu
    end
  end

  def open_saved_game
    puts "Enter the file name of the saved game:"
    file_name = gets.chomp
    if File.exist?(file_name)
      loaded_game = Game.load_game(file_name)
      loaded_game.menu
    else
      puts "File not found. Please enter a valid file name."
      open_saved_game
    end
  end

  def start
    until @num_guesses == 10 || check_win
      num_guesses_left = 10 - @num_guesses
      display_word
      puts "You have #{num_guesses_left} guesses left."
      puts "You have guessed: #{@letters_guessed}."
      puts 'Type "save" to save the game, "exit" to leave, or guess a letter:'
      input = gets.chomp.downcase
      if input == 'save'
        save_game('saved_game.yaml')
        puts 'Game saved. Continue guessing.'
      elsif input == 'exit'
        puts 'See you later!'
        menu
      elsif input.length != 1
        puts 'Type only one letter.'
      else
        guess(input)
      end
    end

    display_word
    return unless check_win

    puts "Congratulations! You guessed the word `#{@word_selected}` correctly."
  end
end

def load_words(file)
  words = []
  File.open(file, 'r') do |file|
    file.each_line do |line|
      words << line.chomp
    end
  end
  words
end

def random_word(words)
  filtered_words = words.select { |word| word.length >= 5 && word.length <= 12 }
  filtered_words.sample
end
