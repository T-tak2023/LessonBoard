class InstructorsController < ApplicationController
  def profile
    @instructor = current_instructor
  end
end
