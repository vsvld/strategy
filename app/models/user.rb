class User < ActiveRecord::Base
  include Clearance::User

  has_many :companies

  validates :first_name, length: { maximum: 64 }, presence: true
  validates :last_name, length: { maximum: 64 }, presence: true
  validates :organisation, length: { maximum: 64 }, presence: true
  validates :email, length: { maximum: 64 },
                    format: { with: EMAIL_REGULAR_EXPRESSION, message: 'is incorrect' },
                    presence: true,
                    uniqueness: true


  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
