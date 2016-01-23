class ConcreteStrategy < ActiveRecord::Base
  belongs_to :strategy_model

  validates :name, presence: true
  validates :description, presence: true
end
