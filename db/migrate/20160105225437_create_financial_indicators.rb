class CreateFinancialIndicators < ActiveRecord::Migration
  def change
    create_table :financial_indicators do |t|
      t.string :name
      t.float :value
      t.string :units
      t.string :group
      t.references :period, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
