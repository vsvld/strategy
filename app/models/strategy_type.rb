class StrategyType < ActiveRecord::Base
  has_many :strategy_models

  validates :name, presence: true
end
