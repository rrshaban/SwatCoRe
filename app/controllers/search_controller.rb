class SearchController < ApplicationController
  # include pg_search

  def form
    # search queries come here
  end

  def search
    query = q_params
    @departments = PgSearch.multisearch(query).where(:searchable_type => "Department")
    @professors = PgSearch.multisearch(query).where(:searchable_type => "Professor")
    @courses = PgSearch.multisearch(query).where(:searchable_type => "Course")

    if @departments.none? and @professors.none? and @courses.none?
      redirect_to search_path, notice: 'No results found. Please double-check your query.'
    end
  end

  private
  def q_params
      params.permit(:search)[:search]
    end
end
