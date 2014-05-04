module ApplicationHelper

  def showTrendingFundedCompanies
    companies = {}
    response = HTTParty.get("http://static.crunchbase.com/daily/content_crunchbase.json")
    response["funding_rounds"].each do |item|
      company_funding = item["raised_string"].gsub("$","").gsub(".", "").gsub("MM","000000").gsub("K","000").gsub("unknown","0").to_i
      companies[item["company_name"]] = company_funding
    end
    sorted_companies = companies.sort_by {|key, value| value}.reverse
    top_companies = sorted_companies.map {|company| company.first}
    return top_companies[0..4]
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

  def get

  end

end
