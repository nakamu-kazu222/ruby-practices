require_relative 'game'

scores = ARGV[0]
scores = scores.split(',')
game = Game.new(scores)
puts game.calc_score
