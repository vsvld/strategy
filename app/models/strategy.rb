class Strategy < ActiveRecord::Base
  belongs_to :company
  belongs_to :strategy_model
  belongs_to :periods_group
  belongs_to :concrete_strategy
  has_one :strategy_type, through: :strategy_model
  has_many :periods, through: :periods_group

  validates :company, presence: true
  validates :strategy_model, presence: true

  # TODO change for other strats
  after_create  :calculate_integral_indicators,
                :forecast_integral_indicator,
                :calculate_profitability_average_growth,
                :choose_strategy


  # weights_hash = { 'fin_group_name': { group_weight: 20, 'indicator_name': 20, ... }, ... }
  def calculate_integral_indicators(weights_hash=strategy_model.default_weights_hash)
    max_hash = {}

    StrategyModel.default_financial_indicators_names.each do |fin_name|
      all_values = []
      periods.each { |p| all_values << p.financial_indicators.where(name: fin_name).take.value }
      max_hash[fin_name] = all_values.max
    end

    # calculate integral indicator for each period
    periods.each do |period|
      groups_result_hash = {}

      # iterating through financial groups and its indicators (names)
      strategy_model.financial_indicators_names_in_groups.each do |fin_group_name, fin_names|
        # to collect weighted integral indicators
        values_in_group = []

        # TODO consider destimulant
        # getting indicators in this group for current periods
        fin_names.each do |fin_name|
          fin_ind = period.financial_indicators.where(name: fin_name).take
          integral_indicator = fin_ind.value / max_hash[fin_ind.name]
          weighted_integral_indicator = integral_indicator * ((weights_hash[fin_group_name.to_sym][fin_name.to_sym]).to_f / 100)
          values_in_group << weighted_integral_indicator
        end

        # sum weighted indicators in group to get group's indicator
        groups_result_hash[fin_group_name] = values_in_group.inject(:+)
      end

      period_integral_indicator = 0

      # calculate indicator for whole period
      groups_result_hash.each do |fin_group_name, group_indicator|
        period_integral_indicator += group_indicator * ((weights_hash[fin_group_name.to_sym][:group_weight]).to_f / 100)
      end

      puts [period.id, period_integral_indicator].join(' --- ')

      # adding integral indicator to the period
      pgi = Pgi.where(period: period, periods_group: periods_group).take
      pgi.integral_indicator = IntegralIndicator.new(value: period_integral_indicator)
      pgi.save
    end

  end

  # середній темп росту рентабельності (формула - http://www.grandars.ru/images/1/review/id/349/2657168c52.jpg)
  def calculate_profitability_average_growth
    company_profitabilities = periods_group.financial_indicators
                                  .joins(:period)
                                  .where(name: 'Чиста рентабельність підприємства', periods: { company_id: company.id })
                                  .order('periods.date_from')
                                  .pluck(:value)

    growths = []
    0.upto(company_profitabilities.size - 2) { |i| growths << (company_profitabilities[i + 1] / company_profitabilities[i]) }

    self.profitability_average_growth = growths.inject(:*) ** (1.0 / growths.size)
    self.save
  end

  def forecast_integral_indicator
    company_int_indicators = periods_group.integral_indicators
                                 .joins(:period)
                                 .where(periods: { company_id: company.id })
                                 .order('periods.date_from')
                                 .pluck(:value)

    period = periods_group.period_type_times_in_year
    next_integral_indicator_value = TeaLeaves.forecast(company_int_indicators, period)

    self.forecast = next_integral_indicator_value
    self.save
  end

  def average_integral_indicator
    company_int_indicators = periods_group.integral_indicators
                                 .joins(:period)
                                 .where(periods: { company_id: company.id })
                                 .pluck(:value)

    company_int_indicators.inject(:+).to_f / company_int_indicators.size
  end

  def choose_strategy
    self.concrete_strategy = strategy_model.choose_strategy(self)
    self.save
  end

end
