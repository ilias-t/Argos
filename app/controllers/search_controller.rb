class SearchController < ApplicationController

  def index
    results = search(params[:query], params[:type])


    render :JSON

  end

  def show
    render :show
  end

  private

  def search(query, type)
    HTTParty.get = ""
  end


end