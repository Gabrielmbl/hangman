class Game
  attr_accessor :words, :word_selected, :indexes_discovered

  def initialize
    @words = load_words('google-10000-english-no-swears.txt')
    @word_selected = random_word(@words)
    @indexes_discovered = []
  end

  def guess(letter)
    @word_selected.each_char.with_index do |character, index|
      indexes_discovered << index if character == letter
    end
    @indexes_discovered
  end

  def display_word
    @word_selected.each_char.with_index do |character, index|
      if @indexes_discovered.include?(index)
        print character
      else
        print "_ "
      end
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
