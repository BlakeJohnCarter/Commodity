json.extract! stock, :id, :stockname, :stockprice, :stocktime, :created_at, :updated_at
json.url stock_url(stock, format: :json)
