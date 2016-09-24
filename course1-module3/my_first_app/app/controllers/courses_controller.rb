class CoursesController < ApplicationController
  def index
    @search_term = 'jhu'
    @courses = Coursera.for(@search_term)
  end
end
