class RemoveGroupFromFinancialIndicators < ActiveRecord::Migration
  def change
    remove_column :financial_indicators, :group, :string
  end
end
