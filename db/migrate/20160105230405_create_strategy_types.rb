class CreateStrategyTypes < ActiveRecord::Migration
  def change
    create_table :strategy_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
