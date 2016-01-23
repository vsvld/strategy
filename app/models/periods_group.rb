class PeriodsGroup < ActiveRecord::Base
  has_many :strategies
  has_many :pgis, dependent: :destroy
  has_many :periods, through: :pgis
  has_many :integral_indicators, through: :pgis, dependent: :destroy

  # for usability
  has_many :companies, -> { distinct }, through: :periods
  has_many :financial_indicators, through: :periods

  validates :periods, presence: true
  validates :period_type, presence: true
  # validates :date_from, presence: true
  # validates :date_to, presence: true
  # TODO validate periods: same period_type and one after another
  # TODO validate periods in other company to match
  # TODO validate n periods for one company for forecast

  # TODO make it work
  after_create :set_dates

  # def integral_indicators_sorted
  #   integral_indicators.includes(:period).order('periods.date_from')
  # end

  def main_company_periods
    periods
  end

  def main_company_periods=(periods_ids)
    # TODO validation
    found_periods = Period.where(id: periods_ids)
    found_periods.each { |period| self.periods << period }
  end

  def competitive_companies
    companies
  end

  def competitive_companies=(companies_ids)
    found_companies = Company.where(id: companies_ids)

    if periods.present?
      found_companies.each do |company|
        periods_arr = []

        periods.each do |period|
          found_period = company.periods.where(period_type: period.period_type, date_from: period.date_from, date_to: period.date_to).take
          periods_arr << found_period if found_period
        end

        if periods_arr.size != periods.size
          errors.add(:base, "Періоди для #{company.name} не відповідають періодам в основній компанії")
          break
        else
          periods_arr.each { |period| self.periods << period }
        end
      end
    end
  end

  def period_type_times_in_year
    case period_type
      when 'month'
        12
      when 'quarter'
        4
      when 'year'
        1
      else
        raise 'unknown period type'
    end
  end

  def name
    "#{period_type} (#{date_from} - #{date_to}) для компаній: #{companies.pluck(:name).join(', ')}"
  end

  private
  def set_dates
    if date_from.blank? || date_to.blank?
      periods_sorted = periods.order(:date_from)
      self.date_from = periods_sorted.first.date_from
      self.date_to = periods_sorted.last.date_to
      self.save
    end
  end

end
