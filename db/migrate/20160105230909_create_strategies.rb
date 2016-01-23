class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.string :name
      t.string :description
      t.references :company, index: true, foreign_key: true
      t.references :strategy_model, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
