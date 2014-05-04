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
    unless response["data"]["relationships"]["funding_rounds"] == nil
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
        unless funding_response["data"]["relationships"]["investments"] == nil
          funding_response["data"]["relationships"]["investments"]["items"].each do |funding_org|
            investing_companies << funding_org["investor"]["name"]
          end
          funding_round["investing_companies"] = investing_companies
          # Key is the series type and round is a hash of data
          funding_data << funding_round
        end
      end
      return funding_data
    else
      return nil
    end
  end

  def getCompanies(response)
    companies_invested_in = []
      response["data"]["relationships"]["investments"]["items"].each do |item|
        companies_invested_in.push(item["invested_in"]["name"])
      end
    return companies_invested_in
  end

  def getCompanyLocations(companies)
    company_ids =[]
    companies.each do |company|
      company = Organizations.find_by_name(company.downcase)
      company_ids.push(company)
    end
    addresses = []
    company_ids.each do |company|
      address_response = HTTParty.get("http://api.crunchbase.com/v/2/organization/#{company.crunchbase_id}?user_key=#{CRUNCHBASE_API_KEY}")
      unless address_response["data"]["relationships"]["headquarters"] == nil
        street = address_response["data"]["relationships"]["headquarters"]["items"][0]["street_1"]
        city = address_response["data"]["relationships"]["headquarters"]["items"][0]["city"]
        state = address_response["data"]["relationships"]["headquarters"]["items"][0]["state"]
        country = address_response["data"]["relationships"]["headquarters"]["items"][0]["country"]
        address = "#{street}, #{city}, #{state}, #{country}"
        addresses.push(address)
      end
    end
    return addresses
  end

  def getInvestorLocations(funding_data)
    names = funding_data.map do |round|
      round["investing_companies"].each do |company|
        company
      end
    end
    addresses = []
    investors = []
    names.flatten!.uniq!.compact!.each do |company_name|
      company = Organizations.find_by_name(company_name.downcase)
      company_response = HTTParty.get("http://api.crunchbase.com/v/2/organization/#{company.crunchbase_id}?user_key=#{CRUNCHBASE_API_KEY}")
      unless company_response["data"]["relationships"]["headquarters"] == nil
        street = company_response["data"]["relationships"]["headquarters"]["items"][0]["street_1"]
        city = company_response["data"]["relationships"]["headquarters"]["items"][0]["city"]
        state = company_response["data"]["relationships"]["headquarters"]["items"][0]["region"]
        country = company_response["data"]["relationships"]["headquarters"]["items"][0]["country_code"]
        address = "#{street}, #{city}, #{state}, #{country}"
        addresses.push(address)
      end
      investors.push(company)
    end
    return [addresses, investors]
  end

end
