class SearchController < ApplicationController

  def index
<<<<<<< HEAD
    # @query = Organizations.find_by_name(params[:query].downcase)
    # @results = search(@query.crunchbase_id)
=======
    @query = Organizations.find_by_name(params[:query].downcase)
    @results = search(@query.crunchbase_id)
>>>>>>> 01311c6a3277e718d9f888149020551b30762cfe
    render :index
  end

private

  def search(query)
    HTTParty.get("http://api.crunchbase.com/v/2/organization/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end

end
