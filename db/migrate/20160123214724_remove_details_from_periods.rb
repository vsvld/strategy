class RemoveDetailsFromPeriods < ActiveRecord::Migration
  def change
    remove_column :periods, :details, :text
  end
end
