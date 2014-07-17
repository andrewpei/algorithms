require_relative './complex_predictor.rb'
require_relative './human_trained_predictor.rb'
# predictor=AnswerPredictor.new
# predictor.train!
data=predictor.instance_variable_get("@data")
data[:philosophy][:counts].to_a.sort_by { |k, v| -v }.take(300)

sets = []; Predictor::CATEGORIES.each { |cat| sets << Set.new(data[cat][:counts].to_a.sort_by { |k, v| -v }.take(200).map(&:first)) }
sets.reduce { |s1, s2| s1 & s2 }