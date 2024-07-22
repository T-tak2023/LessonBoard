class StudentsController < ApplicationController
  before_action :authenticate_instructor!

  def index
    @students = current_instructor.students
  end
end
