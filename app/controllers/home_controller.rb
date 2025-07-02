class HomeController < ApplicationController
  def index
  end

  def create
    calculator = SalaryCalculatorService.new(
      salary_amount: params[:salary_amount],
      salary_type: params[:salary_type],
      daily_hours: params[:daily_hours],
      weekly_hours: params[:weekly_hours],
      selected_month: params[:selected_month],
      currency: params[:currency]
    )

    results = calculator.calculate

    # Assign results to instance variables for the view
    @hourly = results[:hourly]
    @daily = results[:daily]
    @monthly = results[:monthly]
    @annual = results[:annual]
    @current_month_earnings = results[:current_month_earnings]
    @hourly_converted = results[:hourly_converted]
    @daily_converted = results[:daily_converted]
    @monthly_converted = results[:monthly_converted]
    @annual_converted = results[:annual_converted]
    @current_month_earnings_converted = results[:current_month_earnings_converted]
    @current_month_name = results[:current_month_name]
    @working_days_current_month = results[:working_days_current_month]
    @currency_symbol = results[:currency_symbol]
    @currency_code = results[:currency_code]
    @exchange_rate = results[:exchange_rate]
    @has_conversion = results[:has_conversion]
    @daily_hours = results[:daily_hours]
    @weekly_hours = results[:weekly_hours]
    @weeks_per_month = results[:weeks_per_month]

    respond_to do |format|
      format.turbo_stream
    end
  end
end
