class SearchController < ApplicationController
  include ApplicationHelper

  def index
    gon.searchQuery = params[:query]
    @query = (params[:query].downcase.gsub(" ", "-"))
    @response = search(@query)
    @funding_data = getFundingRounds(@response)
    if @funding_data != nil
      @funding_companies = getInvestorLocations(@funding_data)
      @locations = @funding_companies[0]
      @investors = @funding_companies[1]
      @latest_funding = getLatestFunding(@response)
      @info = {"locations" => @locations, "companies" => @investors}
      @funding_arrays = @funding_data.map do |round|
        round["investing_companies"].map do |company|
          company
        end
      end
    else
      @companies = getCompanies(@response)
      @company_locations = getCompanyLocations(@companies)
      @info = {"locations" => @company_locations, "companies" => @companies}
    end
    @company_name = getCompanyName(@response)
    @company_description = getCompanyDescription(@response)
    # @markets = getMarkets(@response)
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
