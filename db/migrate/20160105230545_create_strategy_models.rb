class CreateStrategyModels < ActiveRecord::Migration
  def change
    create_table :strategy_models do |t|
      t.string :name
      t.references :strategy_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
