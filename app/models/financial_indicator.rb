class FinancialIndicator < ActiveRecord::Base
  belongs_to :period

  validates :name, presence: true
  validates :value, presence: true
end
