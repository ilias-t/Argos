class WelcomeController < ApplicationController
require 'pry'

  def index
    binding.pry
    render :index
  end

end
