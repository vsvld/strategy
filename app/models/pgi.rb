class Pgi < ActiveRecord::Base
  belongs_to :periods_group
  belongs_to :period
  belongs_to :integral_indicator

  validates :periods_group, presence: true
  validates :period, presence: true
end
