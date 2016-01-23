class AddConcreteStrategyToStrategy < ActiveRecord::Migration
  def change
    add_reference :strategies, :concrete_strategy, index: true, foreign_key: true
  end
end
