module ApplicationHelper

  def showTrendingFundedCompanies
    # companies = {}
    new_top_companies = []
    response = HTTParty.get("http://static.crunchbase.com/daily/content_crunchbase.json")
    response["funding_rounds"].each do |item|
      company_info = {}
      company_funding = item["raised_string"].gsub("$","").gsub(".", "").gsub("MM","000000").gsub("K","000").gsub("unknown","0").to_i
      company_info["funding_value"] = company_funding
      company_info["company_name"] = item["company_name"]
      company_info["logo_url"] = item["logo_url"]
      company_info["raised_string"] = item["raised_string"]

      new_top_companies << company_info
    end
    sorted_companies = new_top_companies.sort_by {|company| company["funding_value"]}.reverse
    # adding logo URL & Raised amount
    # sorted_companies.each do |key, value|
    #   company_name = key
    #   response["funding_rounds"][
    # end
    # top_companies = sorted_companies.map {|company| company.first}
    # return top_companies[0..4]
    return sorted_companies[0..4]
  end


# CrunchBase API helper methods
  def getCompanyName(response)
    return response["data"]["properties"]["name"]
  end

  def getCompanyDescription(response)
    return response["data"]["properties"]["description"]
  end

  def getPrimaryRole(response)
    return response["data"]["properties"]["primary_role"]
  end

  def getFoundingDate(response)
    month = response["data"]["properties"]["founded_on_month"]
    day = response["data"]["properties"]["founded_on_day"]
    year = response["data"]["properties"]["founded_on_year"]
    founded_date = month.to_s + "/" + day.to_s + "/" + year.to_s
    return founded_date
  end

  def getFundingRounds(response)
    funding_data = []
    funding_round_paths = response["data"]["relationships"]["funding_rounds"]["items"].map { |round| round["path"]}
    funding_round_paths.each do |round|
      funding_round = {}
      investing_companies = []
      # API calls to get investment details for each round
      funding_response = HTTParty.get("http://api.crunchbase.com/v/2/#{round}?user_key=#{CRUNCHBASE_API_KEY}")
      funding_round["series"] = funding_response["data"]["properties"]["series"]
      funding_round["money_raised"] = funding_response["data"]["properties"]["money_raised_usd"]
      funding_round["announced_on"] = funding_response["data"]["properties"]["announced_on"]
      # Placing an array of funding organizations in the series hash
      funding_response["data"]["relationships"]["investments"]["items"].each do |funding_org|
        investing_companies << funding_org["investor"]["name"]
      end
      funding_round["investing_companies"] = investing_companies
      # Key is the series type and round is a hash of data
      funding_data << funding_round
    end
    return funding_data
  end

  def getInvestorLocations(funding_data)
    names = funding_data.map do |round|
      round["investing_companies"].each do |company|
        company
      end
    end
    addresses = names.flatten!.uniq!.compact!.each do |company_name|
      company_response = HTTParty.get("http://api.crunchbase.com/v/2/#{company_name}?user_key=#{CRUNCHBASE_API_KEY}")
      street = company_response["data"]["relationships"]["headquarters"]["items"]["street_1"]
      city = company_response["data"]["relationships"]["headquarters"]["items"]["city"]
      state = company_response["data"]["relationships"]["headquarters"]["items"]["region"]
      country = company_response["data"]["relationships"]["headquarters"]["items"]["country_code"]
      address = "#{street}, #{city}, #{state}, #{country}"
      return address
    end
    return addresses
  end

end
