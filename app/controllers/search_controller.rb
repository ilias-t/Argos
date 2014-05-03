class SearchController < ApplicationController


  def index
    @query = Organization.find_by_name(params[:query].downcase)
    @results = search(@query.crunchbase_id, params[:type])
    render :index
  end

private

  def search(query)
    HTTParty.get("http://api.crunchbase.com/v/2/organization/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end

end