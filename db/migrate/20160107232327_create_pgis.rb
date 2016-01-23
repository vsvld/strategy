class CreatePgis < ActiveRecord::Migration
  def change
    create_table :pgis do |t|
      t.belongs_to :periods_group, index: true, foreign_key: true
      t.belongs_to :period, index: true, foreign_key: true
      t.belongs_to :integral_indicator, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
