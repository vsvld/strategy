class AddForecastToStrategy < ActiveRecord::Migration
  def change
    add_column :strategies, :forecast, :float
  end
end
