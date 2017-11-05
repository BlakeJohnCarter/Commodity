class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :stockname
      t.string :stockprice
      t.string :stocktime

      t.timestamps
    end
  end
end
