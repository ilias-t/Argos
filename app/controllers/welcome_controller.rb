class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @top_companies = showTrendingFundedCompanies
    # @companies_funding = showTrendingFundedCompanies.map { | company | getFundingRounds(HTTParty.get("http://api.crunchbase.com/v/2/#{company}?user_key=#{CRUNCHBASE_API_KEY}")) }
    render :index
  end

end
