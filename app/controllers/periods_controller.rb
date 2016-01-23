class PeriodsController < ApplicationController
  before_action :get_company
  before_action :set_period, only: [:show, :edit, :update, :destroy]

  # GET /periods
  # GET /periods.json
  def index
    @periods = @company.periods.order(:date_from)
  end

  # GET /periods/1
  # GET /periods/1.json
  def show
  end

  # GET /periods/new
  def new
    @period = @company.periods.new
    StrategyModel.default_financial_indicators_names.each { |name| @period.financial_indicators.new(name: name) }
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  # POST /periods.json
  def create
    @period = @company.periods.new(period_params)

    respond_to do |format|
      if @period.save
        format.html { redirect_to company_period_path(@company, @period), notice: 'Period was successfully created.' }
        format.json { render :show, status: :created, location: @period }
      else
        format.html { render :new }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periods/1
  # PATCH/PUT /periods/1.json
  def update
    respond_to do |format|
      if @period.update(period_params)
        format.html { redirect_to company_period_path(@company, @period), notice: 'Period was successfully updated.' }
        format.json { render :show, status: :ok, location: @period }
      else
        format.html { render :edit }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.json
  def destroy
    @period.destroy
    respond_to do |format|
      format.html { redirect_to company_periods_url(@company), notice: 'Period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def get_company
    @company = Company.find(params[:company_id])
  end

  def set_period
    @period = @company.periods.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def period_params
    params.require(:period).permit(:period_type, :date_from, :date_to, financial_indicators_attributes: [:id, :name, :value, :units, :_destroy])
  end
end
