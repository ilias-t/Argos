class SearchController < ApplicationController
  include ApplicationHelper

  def index
    @query = Organizations.find_by_name(params[:query].downcase)
    @response = search(@query.crunchbase_id)
    @funding_data = getFundingRounds(@response)
    if @funding_data != nil
      @funding_companies = getInvestorLocations(@funding_data)
      @locations = @funding_companies[0]
      @investors = @funding_companies[1]
      @info = {"locations" => @locations, "companies" => @investors}
    else
      @companies = getCompanies(@response)
      @company_locations = getCompanyLocations(@companies)
      @info = {"locations" => @companies_locations, "companies" => @companies}
    end
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @info}
    end
  end

private

  def search(query)
    HTTParty.get("http://api.crunchbase.com/v/2/organization/#{query}?user_key=#{CRUNCHBASE_API_KEY}")
  end

end
