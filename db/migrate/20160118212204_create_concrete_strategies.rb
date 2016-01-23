class CreateConcreteStrategies < ActiveRecord::Migration
  def change
    create_table :concrete_strategies do |t|
      t.string :name
      t.text :description
      t.references :strategy_model, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
