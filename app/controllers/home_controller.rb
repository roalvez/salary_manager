class HomeController < ApplicationController
  def index
  end

  def create
    @hourly = params[:hourly_wage].to_f
    @daily = @hourly * 8
    weekly_hours = 40
    weeks_per_month = 52.0 / 12
    @monthly = @hourly * weekly_hours * weeks_per_month
    @annual = @hourly * weekly_hours * 52

    respond_to do |format|
      format.turbo_stream
    end
  end
end
