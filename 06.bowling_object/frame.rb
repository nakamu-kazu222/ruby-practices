# frozen_string_literal: true

class Frame
  attr_accessor :first_shot, :second_shot

  def initialize(first_shot, second_shot)
    @first_shot = first_shot
    @second_shot = second_shot
  end

  def score
    @first_shot + @second_shot
  end

  def strike?
    @first_shot == 10
  end

  def spare?
    !strike? && score == 10
  end
end
