class SearchController < ApplicationController
  include ApplicationHelper

  def index
    @query = (params[:query].downcase.gsub(" ", "-"))
    @response = search(@query)
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
    @company_name = getCompanyName(@response)
    @company_description = getCompanyDescription(@response)
    @latest_funding = getLatestFunding(@response)
    @markets = getMarkets(@response)
    binding.pry
    @company_photo = getCompanyPhoto(@response)

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
