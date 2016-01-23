class Period < ActiveRecord::Base
  belongs_to :company
  has_many :financial_indicators, dependent: :destroy
  has_many :pgis
  has_many :periods_groups, through: :pgis, dependent: :destroy
  has_many :integral_indicators, through: :pgis, dependent: :destroy

  accepts_nested_attributes_for :financial_indicators, allow_destroy: true

  validates :period_type, presence: true
  validates :date_from, presence: true
  validates :date_to, presence: true


  def name
    "#{period_type} (#{date_from} - #{date_to})"
  end

end
