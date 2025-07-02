class SalaryCalculatorService
  attr_reader :salary_amount, :salary_type, :daily_hours, :weekly_hours, :selected_month, :currency

  def initialize(salary_amount:, salary_type: 'hourly', daily_hours: 8, weekly_hours: 40, selected_month: nil, currency: nil)
    @salary_amount = salary_amount.to_f
    @salary_type = salary_type || 'hourly'
    @daily_hours = daily_hours.to_f > 0 ? daily_hours.to_f : 8
    @weekly_hours = weekly_hours.to_f > 0 ? weekly_hours.to_f : 40
    @selected_month = selected_month
    @currency = currency.present? ? currency : nil
  end

  def calculate
    {
      hourly: hourly_wage,
      daily: daily_wage,
      monthly: monthly_wage,
      annual: annual_wage,
      current_month_earnings: current_month_earnings,
      hourly_converted: convert_currency(hourly_wage),
      daily_converted: convert_currency(daily_wage),
      monthly_converted: convert_currency(monthly_wage),
      annual_converted: convert_currency(annual_wage),
      current_month_earnings_converted: convert_currency(current_month_earnings),
      current_month_name: current_month_name,
      working_days_current_month: working_days_current_month,
      currency_symbol: currency_symbol,
      currency_code: currency || 'USD',
      exchange_rate: exchange_rate,
      has_conversion: currency.present?,
      daily_hours: daily_hours,
      weekly_hours: weekly_hours,
      weeks_per_month: weeks_per_month
    }
  end

  private

  def hourly_wage
    @hourly_wage ||= case salary_type
    when 'hourly'
      salary_amount
    when 'monthly'
      salary_amount / (weekly_hours * weeks_per_month)
    when 'annual'
      salary_amount / (weekly_hours * 52.0)
    else
      salary_amount
    end
  end

  def daily_wage
    @daily_wage ||= hourly_wage * daily_hours
  end

  def weeks_per_month
    @weeks_per_month ||= 52.0 / 12.0
  end

  def monthly_wage
    @monthly_wage ||= hourly_wage * weekly_hours * weeks_per_month
  end

  def annual_wage
    @annual_wage ||= hourly_wage * weekly_hours * 52.0
  end

  def selected_date
    @selected_date ||= begin
      if selected_month.present?
        # Handle both date field format (YYYY-MM-DD) and month field format (YYYY-MM)
        date_parts = selected_month.split('-')
        year = date_parts[0].to_i
        month = date_parts[1].to_i
        Date.new(year, month, 1)
      else
        Date.current
      end
    end
  end

  def working_days_current_month
    @working_days_current_month ||= begin
      month_start = selected_date.beginning_of_month
      month_end = selected_date.end_of_month
      (month_start..month_end).count { |day| day.wday.between?(1, 5) }
    end
  end

  def current_month_earnings
    @current_month_earnings ||= hourly_wage * daily_hours * working_days_current_month
  end

  def current_month_name
    @current_month_name ||= selected_date.strftime("%B %Y")
  end

  def convert_currency(amount)
    return amount unless currency
    (amount * exchange_rate).round(2)
  end

  def exchange_rate
    @exchange_rate ||= currency ? ExchangeRateService.get_rate('USD', currency) : 1.0
  end

  def currency_symbol
    case currency
    when 'EUR' then '€'
    when 'GBP' then '£'
    when 'BRL' then 'R$'
    when 'CAD', 'AUD' then '$'
    when 'JPY' then '¥'
    when 'CHF' then 'CHF'
    else '$'
    end
  end
end
