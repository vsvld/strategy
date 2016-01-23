class CreatePeriodsGroups < ActiveRecord::Migration
  def change
    create_table :periods_groups do |t|
      t.string :period_type
      t.date :date_from
      t.date :date_to

      t.timestamps null: false
    end
  end
end
