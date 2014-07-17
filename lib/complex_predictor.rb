require_relative 'predictor'
# Requirement for this class is to not use any human intuition to help out the program
# it has to be generic for any genre of books. So no human inputted keywords. Also no major gems

class ComplexPredictor < Predictor
  def train!
    @data = {}

    CATEGORIES.each do |category|
      @data[category] = {}
    end

    #Ideally I would have a step which processes the text even further to correct for misspellings, combines
    #synonyms, and focuses on the root of a word e.g. training, trains, trained = train
    
    @all_books.each { |category, book|
      book.each { |filename, tokens|
        tokens.each { |token|
          if good_token?(token) #Kind of a major bottleneck I'm guessing
            @data[category][:word_list][token][filename] = (@data[category][:word_list][token][filename] || 0) + 1
            @data[category][:book_word_counts][filename] = (@data[category][:book_word_counts][filename] || 0) + 1
          end
        }
      }
    }

    @data.each { |category|
      # First step is to filter out words which are book specific
      @data[category][:word_list].each { |token|
        word = @data[category][:word_list][token]
        word[:frequency] = []

        word.each { |book|
          #Need to get average frequency for a word in a respective book
          word[:frequency] << word[book].to_f/@data[category][:book_word_counts][book].to_f
        }
        #Come up with method to decide if a word 'appears' in a book. Maybe >33% the median value means it counts
        #Then come up with a multiplier. Not sure if I should use a mean or median here. Not using a true median here
        word_frequency_median = median(word[:frequency]) 
        number_book_appearances = number_books_word_appears_in(word[:frequency], word_frequency_median)

        word[:category_importance] = Math.exp(10.0 * number_book_appearances.to_f/word[:frequency].length.to_f - 5) * word_frequency_median
      }
    }

    


  end

  def median(array)
    sorted = array.sort
    len = sorted.length
    return (sorted[(len-1)/2] + sorted[len/2])/2.0
  end

  def number_books_word_appears_in(word_freq_array, median)
    number_book_appearances = 0
    word_freq_array.each { |appearance_rate|
      if appearance_rate > (median * 0.33)
        number_book_appearances += 1
      end
    }
    return number_book_appearances
  end

  def predict(tokens)
    
  end
end

@data = {
  philosophy: {
    book_word_counts: {
      book1: 100,
      book2: 200
    },
    word_list: {
      token1: {
        book1: 20,
        book2: 20,
        category_importance: 85
      },
      token2: {
        book1: 43,
        book2: 27
      },
      token3: {
        book1: 83,
        book2: 57
      }
    }
  },
  astronomy: {
    book_word_counts: {
      book3: 300,
      book4: 600
    },
    word_list: {
      token1: {
        book3: 15,
        book4: 24,
      },
      token4: {
        book3: 84,
        book4: 51  
      },
      token5: {
        book3: 69,
        book4: 42
      }
    }
  }
}