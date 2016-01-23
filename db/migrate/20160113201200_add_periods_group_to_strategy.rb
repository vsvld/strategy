class AddPeriodsGroupToStrategy < ActiveRecord::Migration
  def change
    add_reference :strategies, :periods_group, index: true, foreign_key: true
  end
end
