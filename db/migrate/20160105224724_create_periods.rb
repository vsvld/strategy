class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :period_type
      t.date :date_from
      t.date :date_to
      t.text :details
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
