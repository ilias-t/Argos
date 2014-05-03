class SearchController < ApplicationController

  def index
    results = search(params[:query], params[:type])


    render :JSON

  end

  def show
    render :show
  end

private

  def search(query, type)
    HTTParty.get("http://api.crunchbase.com/v/2/#{type}/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end


end