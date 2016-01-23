class IntegralIndicator < ActiveRecord::Base
  has_one :pgi
  has_one :period, through: :pgi
  has_one :periods_group, through: :pgi
end
