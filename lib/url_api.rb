require 'httparty'

# Api calls for the different commodities
class UrlApi
  # API_URL = 'https://www.quandl.com/api/v3/datasets/MCX/NGX2017.json?api_key=hebPRmzGz8cB2o3vi9wS'
  def initialize(api_url)
    @cust_api_url = api_url
  end

  def unique_url
    response = HTTParty.get(@cust_api_url)
    rescue HTTParty::Error
      {error: 'party error, API data returned is not well formated.'}
    rescue StandardError
      {error: 'Standard error, API data returned is not well formated.'}
    json = JSON.parse(response.body)
    json['url']
  end

end