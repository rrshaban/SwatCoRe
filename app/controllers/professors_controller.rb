class ProfessorsController < ApplicationController
  # before_action :logged_in_user
  before_action :set_prof, only: [:show, :edit, :update, :destroy]
  before_action :get_depts
  before_action :get_profs
  before_action :admin_user, only: [:edit, :update, :destroy]

  def index
    @professors = Professor.order(name: :asc)
  end

  def new
    @professor = Professor.new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @professor.update(professor_params)
        format.html { redirect_to @professor, notice: 'Professor was successfully updated.' }
        format.json { render :show, status: :ok, location: @professor }
      else
        format.html { render :edit }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @professor = Professor.new(professor_params)

    respond_to do |format|
      if @professor.save
        format.html { redirect_to @professor, notice: 'Professor was successfully created.' }
        format.json { render :show, status: :created, location: @professor }
      else
        format.html { render :new }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @professor.destroy
    respond_to do |format|
      format.html { redirect_to professors_url, notice: 'Professor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private

    def set_prof
      @professor = Professor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def professor_params
      params.require(:professor).permit(:name, :department_id)
    end

end
