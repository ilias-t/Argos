module ApplicationHelper

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


end
