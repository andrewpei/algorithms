require_relative 'predictor'

class HumanTrainedPredictor < Predictor
  # Public: Trains the predictor on books in our dataset. This method is called
  # before the predict() method is called.
  #
  # Returns nothing.
  def train!
    @data = {
      philosophy: {},
      archaelogy: {},
      astronomy: {},
      religion: {}
    }
    
  end

  def predict(tokens)
    

  end
end