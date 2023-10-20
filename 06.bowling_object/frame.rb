# frozen_string_literal: true

class Frame
  attr_accessor :first_shot, :second_shot

  FULL_SCORE = 10

  def initialize(first_shot, second_shot)
    @first_shot = first_shot
    @second_shot = second_shot
  end

  def score
    @first_shot + @second_shot
  end

  def strike?
    @first_shot == FULL_SCORE
  end

  def spare?
    !strike? && score == FULL_SCORE
  end
end
