class AddProfitabilityAverageGrowthToStrategy < ActiveRecord::Migration
  def change
    add_column :strategies, :profitability_average_growth, :float
  end
end
