# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(scores)
    @shots = parse_scores(scores)
    @frames = create_frames
    @point = 0
  end

  def parse_scores(scores)
    shots = []
    scores.each do |s|
      if s == 'X'
        shots << 10
        shots << 0
      else
        shots << s.to_i
      end
    end
    shots
  end

  def create_frames
    frames = []
    @shots.each_slice(2) do |first, second|
      frames << Frame.new(first, second)
    end
    frames
  end

  def calc_score
    10.times do |i|
      if @frames[i].strike?
        @point += @frames[i + 1].first_shot
        @point += if @frames[i + 1].strike?
                    @frames[i + 2].first_shot
                  else
                    @frames[i + 1].second_shot
                  end
      elsif @frames[i].spare?
        @point += @frames[i + 1].first_shot
      end
      @point += @frames[i].score
    end
    @point
  end
end
