class Hangman
  attr_accessor :words

  def initialize
    @words = load_words('google-10000-english-no-swears.txt')
  end
  
end

class Game
  attr_accessor :word_selected, :indexes_discovered, :num_guesses

  def initialize
    @hangman = Hangman.new
    @word_selected = random_word(@hangman.words)
    @indexes_discovered = []
    @num_guesses = 0
  end

  def guess(letter)
    @word_selected.each_char.with_index do |character, index|
      if character == letter
        @indexes_discovered << index unless @indexes_discovered.include?(index)
      end
    end
    @num_guesses += 1
  end

  def check_win
    if @indexes_discovered.length == @word_selected.length and @num_guesses <= 10
      true
    elsif @num_guesses == 10
      puts "You used all your 10 guesses. Game is over, try again!"
      false
    end
  end

  def display_word
    @word_selected.each_char.with_index do |character, index|
      if @indexes_discovered.include?(index)
        print character
      else
        print "_ "
      end
    end
    print "\n"
  end

  def start
    until @num_guesses == 10 || self.check_win
      num_guesses_left = 10 - @num_guesses
      self.display_word
      puts "You have #{num_guesses_left} guesses left."
      puts 'Guess a letter:'
      letter = gets.chomp.to_s
      if letter.length != 1
        puts 'Type only one letter.'
      else
        self.guess(letter)
      end
    end
    
    self.display_word
    if self.check_win
      puts "Congratulations! You guessed the word `#{@word_selected}` correctly."
    end
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


