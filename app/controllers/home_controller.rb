class HomeController < ApplicationController
  def index
  end

  def create
    @hourly = params[:hourly_wage].to_f
    @daily_hours = params[:daily_hours].to_f > 0 ? params[:daily_hours].to_f : 8
    @weekly_hours = params[:weekly_hours].to_f > 0 ? params[:weekly_hours].to_f : 40

    # Calculate daily wage
    @daily = @hourly * @daily_hours

    # Calculate weeks per month dynamically using current date
    current_date = Date.current
    current_year = current_date.year
    weeks_per_year = 52.0 # Standard business calculation
    @weeks_per_month = weeks_per_year / 12.0

    # Calculate current month working days
    current_month_start = current_date.beginning_of_month
    current_month_end = current_date.end_of_month
    @working_days_current_month = (current_month_start..current_month_end).count { |day|
      day.wday.between?(1, 5) # Monday to Friday (1-5)
    }
    @current_month_earnings = @hourly * @daily_hours * @working_days_current_month
    @current_month_name = current_date.strftime("%B %Y")

    @monthly = @hourly * @weekly_hours * @weeks_per_month
    @annual = @hourly * @weekly_hours * weeks_per_year

    respond_to do |format|
      format.turbo_stream
    end
  end
end
