class Company < ActiveRecord::Base
  belongs_to :user
  has_many :periods, dependent: :destroy
  has_many :strategies, dependent: :destroy
  has_many :periods_groups, -> { distinct }, through: :periods

  validates :name, length: { maximum: 128 }, presence: true
end
