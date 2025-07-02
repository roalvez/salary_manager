require 'net/http'
require 'json'

class ExchangeRateService
  API_URL = 'https://api.fxratesapi.com/latest'
  CACHE_DURATION = 1.hour

  def self.get_rate(from_currency, to_currency)
    return 1.0 if from_currency == to_currency

    new.get_rate(from_currency, to_currency)
  end

  def get_rate(from_currency, to_currency)
    rates = fetch_rates(from_currency)
    rates[to_currency] || 1.0
  rescue => e
    Rails.logger.error "Error fetching exchange rate: #{e.message}"
    # Fallback to hardcoded rates if API fails
    fallback_rates(from_currency, to_currency)
  end

  private

  def fetch_rates(base_currency)
    cache_key = "exchange_rates_#{base_currency}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_DURATION) do
      uri = URI("#{API_URL}?base=#{base_currency}")
      response = Net::HTTP.get_response(uri)

      if response.code == '200'
        data = JSON.parse(response.body)
        data['rates'] || {}
      else
        {}
      end
    end
  end

  def fallback_rates(from_currency, to_currency)
    # Fallback rates in case API is down
    rates = {
      'USD' => {
        'EUR' => 0.85,
        'GBP' => 0.73,
        'BRL' => 5.20,
        'CAD' => 1.25,
        'AUD' => 1.35,
        'JPY' => 110.0,
        'CHF' => 0.92
      }
    }

    rates.dig(from_currency, to_currency) || 1.0
  end
end
