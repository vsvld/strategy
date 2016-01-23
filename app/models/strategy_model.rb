# TODO make descendant with concrete model
class StrategyModel < ActiveRecord::Base
  belongs_to :strategy_type
  has_many :concrete_strategies
  has_many :strategies

  validates :name, presence: true
  validates :strategy_type, presence: true

  def self.default_financial_indicators_names
    [
        'Загальна рентабельність підприємства',
        'Чиста рентабельність підприємства',
        'Рентабельність власного капіталу',
        'Загальна рентабельність виробничих фондів',

        'Чистий прибуток до обсягу реалізації продукції',
        'Загальний прибуток до обсягу реалізації продукції',

        'Віддача від активів',
        'Віддача основних фондів',
        'Оборотність оборотних фондів',
        'Оборотність дебіторської заборгованості',
        'Віддача власного капіталу',

        'Поточний коефіцієнт ліквідності',
        'Індекс постійного активу',
        'Коефіцієнт автономії',
        'Забезпеченість запасів власними оборотними засобами'
    ]
  end

  def financial_indicators_names_in_groups
    if (names = self.class.default_financial_indicators_names).present?
      { 'Прибутковість господарської діяльності': names[0..3],
        'Ефективність управління':                names[4..5],
        'Ділова активність':                      names[6..10],
        'Ліквідність':                            names[11..14] }
    end
  end

  def default_weights_hash
    { 'Прибутковість господарської діяльності':
          { group_weight: 30,
            'Загальна рентабельність підприємства': 25,
            'Чиста рентабельність підприємства': 40,
            'Рентабельність власного капіталу': 20,
            'Загальна рентабельність виробничих фондів': 15 },
      'Ефективність управління':
          { group_weight: 25,
            'Чистий прибуток до обсягу реалізації продукції': 70,
            'Загальний прибуток до обсягу реалізації продукції': 30 },
      'Ділова активність':
          { group_weight: 25,
            'Віддача від активів': 35,
            'Віддача основних фондів': 20,
            'Оборотність оборотних фондів': 20,
            'Оборотність дебіторської заборгованості': 10,
            'Віддача власного капіталу': 15 },
      'Ліквідність':
          { group_weight: 20,
            'Поточний коефіцієнт ліквідності': 20,
            'Індекс постійного активу': 20,
            'Коефіцієнт автономії': 30,
            'Забезпеченість запасів власними оборотними засобами': 30 } }
  end

  def choose_strategy(strategy)
    int_ind_forecast = strategy.forecast
    profitability_av_gr = strategy.profitability_average_growth
    av_int_ind = strategy.average_integral_indicator

    case name

      # основна модель конкурентної стратегії
      when 'Вибір за квадрантами співвідношень конкурентоспроможність/рентабельність'

        if int_ind_forecast >= 0.5 && profitability_av_gr < 1
          # квадрант зверху зліва
          concrete_strategies.where(name: 'Стратегія горизонтальної інтеграції').take
        elsif int_ind_forecast >= 0.5 && profitability_av_gr >= 1
          # квадрант зверху справа
          concrete_strategies.where(name: 'Стратегія диференціації продукції').take
        elsif int_ind_forecast < 0.5 && profitability_av_gr < 1
          # квадрант знизу зліва
          concrete_strategies.where(name: 'Стратегія мінімізації витрат').take
        else
          # квадрант знизу справа
          concrete_strategies.where(name: 'Стратегія диверсифікації виробництва').take
        end

      # основна модель базової стратегії
      when 'Вибір за стратегічним і тактичним рівнями конкурентоспроможності.'
        if int_ind_forecast.between?(0, 2/3) && av_int_ind.between?(0, 1/3)
          concrete_strategies.where(name: 'Стратегія виживання').take
        elsif int_ind_forecast.between?(1/3, 1) && av_int_ind.between?(2/3, 1)
          concrete_strategies.where(name: 'Стратегія зростання').take
        else
          concrete_strategies.where(name: 'Стратегія стабілізації').take
        end

      else
        raise 'Неможливо обрати стратегію за цією моделлю!'
    end

  end

  def name_with_type
    [strategy_type.name, name].join(': ')
  end

end
