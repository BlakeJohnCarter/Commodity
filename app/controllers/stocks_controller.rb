require 'url_api'

class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    if $t
      $t.kill
    end
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # Requests to insert commodities into the database every 10 seconds
  # GET /stocks/new
  def new
    @stock = Stock.all
    Stock.delete_all

    @stock = Stock.new

    def set_interval(delay)
      Thread.new do
        loop do
          sleep delay

          query_results = validation_query_data
          query_results.each do |result|
            @stock = Stock.new(:stockname => result[0], :stockprice => result[1][1], :stocktime => result[1])
            @stock.save
          end

          yield # call passed block
        end
      end
    end

    t1 = Time.now
    $t = set_interval(5) {puts Time.now - t1}

    def validation_query_data()
      gas_api = UrlApi.new('https://www.quandl.com/api/v3/datasets/MCX/NGX2017.json?api_key=hebPRmzGz8cB2o3vi9wS')
      gas_data = gas_api.unique_url["dataset"]["data"][0]

      gold_api = UrlApi.new('https://www.quandl.com/api/v3/datasets/MCX/GMX2017.json?api_key=hebPRmzGz8cB2o3vi9wS')
      gold_data = gold_api.unique_url["dataset"]["data"][0]

      oil_api = UrlApi.new('https://www.quandl.com/api/v3/datasets/MCX/MOX2017.json?api_key=hebPRmzGz8cB2o3vi9wS')
      oil_data = oil_api.unique_url["dataset"]["data"][0]

      zinc_api = UrlApi.new('https://www.quandl.com/api/v3/datasets/MCX/ZNMX2017.json?api_key=hebPRmzGz8cB2o3vi9wS')
      zinc_data = zinc_api.unique_url["dataset"]["data"][0]

      aluminium_api = UrlApi.new('https://www.quandl.com/api/v3/datasets/MCX/ALMX2017.json?api_key=hebPRmzGz8cB2o3vi9wS')
      aluminium_data = aluminium_api.unique_url["dataset"]["data"][0]

      hash_query_results = {:gas_NGX2017 => gas_data, :gold_GMX2017 => gold_data, :oil_MOX2017 => oil_data,
                            :zinc_ZNMX2017 => zinc_data, :aluminium_ALMX2017 => aluminium_data}

    end

  end

  # Delete Records
  def destroy

    @stock = Stock.all
    Stock.delete_all

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:stockname, :stockprice, :stocktime)
    end
end
