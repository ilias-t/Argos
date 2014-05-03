class SearchController < ApplicationController

  # def index
  #   if params[:type] == "person"
  #     @query = People.where(:name == params[:query])
  #   elsif params[:type] == "organization"
  #     @query = Organization.where(:name == params[:query])
  #   end
  #   @results = search(@query, params[:type])

  #   render :JSON

  # end

  def show
    if params[:type] == "person"
      @query = People.where(:name == params[:query])
    elsif params[:type] == "organization"
      @query = Organization.where(:name == params[:query])
    end
    @results = search(@query.crunchbase_id, params[:type])
    render :show
  end

private

  def search(query, type)
    HTTParty.get("http://api.crunchbase.com/v/2/#{type}/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end



end