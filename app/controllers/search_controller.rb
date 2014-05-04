class SearchController < ApplicationController
  include ApplicationHelper

  def index
    @query = Organizations.find_by_name(params[:query].downcase)
    @response = search(@query.crunchbase_id)
    @funding_data = getFundingRounds(@response)
    @funding_companies = getInvestorLocations(@funding_data)
    @locations = @funding_companies[0]
    @investors = @funding_companies[1]
    binding.pry
    render :index
  end

private

  def search(query)
    HTTParty.get("http://api.crunchbase.com/v/2/organization/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end

end
