class CreateIntegralIndicators < ActiveRecord::Migration
  def change
    create_table :integral_indicators do |t|
      t.float :value

      t.timestamps null: false
    end
  end
end
