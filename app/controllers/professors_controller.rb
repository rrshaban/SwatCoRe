class ProfessorsController < ApplicationController
  before_action :logged_in_user
  before_action :get_depts

  def index
    @professors = Professor.all
  end

  def new
    @professor = Professor.new
  end

  def show
    @professor = Professor.find(params[:id])
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def professor_params
      params.require(:professor).permit(:name)
    end

    def get_depts
       @dept_options = Department.all.map{|d| [d.name, d.id]}
    end
end
