class PeriodsGroupsController < ApplicationController
  before_action :get_company
  before_action :set_periods_group, only: [:show, :edit, :update, :destroy]

  # GET /periods_groups
  # GET /periods_groups.json
  def index
    all = PeriodsGroup.all.to_a
    # show pgs that contain this company's periods
    @periods_groups = all.keep_if { |pg| pg.companies.to_a.include?(@company) }
  end

  # GET /periods_groups/1
  # GET /periods_groups/1.json
  def show
  end

  # GET /periods_groups/new
  def new
    @periods_group = PeriodsGroup.new
    @periods = @company.periods
    @competitors = current_user.companies.where.not(id: @company.id)
  end

  # GET /periods_groups/1/edit
  def edit
  end

  # POST /periods_groups
  # POST /periods_groups.json
  def create
    @periods_group = PeriodsGroup.new(periods_group_params)

    respond_to do |format|
      if @periods_group.save
        format.html { redirect_to company_periods_group_path(@company, @periods_group), notice: 'Periods group was successfully created.' }
        format.json { render :show, status: :created, location: @periods_group }
      else
        format.html { render :new }
        format.json { render json: @periods_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periods_groups/1
  # PATCH/PUT /periods_groups/1.json
  def update
    respond_to do |format|
      if @periods_group.update(periods_group_params)
        format.html { redirect_to company_periods_group_path(@company, @periods_group), notice: 'Periods group was successfully updated.' }
        format.json { render :show, status: :ok, location: @periods_group }
      else
        format.html { render :edit }
        format.json { render json: @periods_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periods_groups/1
  # DELETE /periods_groups/1.json
  def destroy
    @periods_group.destroy
    respond_to do |format|
      format.html { redirect_to company_periods_groups_path(@company), notice: 'Periods group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def get_company
    @company = Company.find(params[:company_id])
  end

  def set_periods_group
    @periods_group = PeriodsGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def periods_group_params
    params.require(:periods_group).permit(:period_type, :main_company_periods => [], :competitive_companies => [])
  end
end
