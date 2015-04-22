class CoursesController < ApplicationController
  # before_action :logged_in_user
  before_action :set_course, only: [:show, :edit, :update, :destroy, :upload]
  before_action :get_depts
  before_action :get_profs
  before_action :admin_user, only: [:edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    redirect_to(search_path) 
  end

  # GET /search
  def search
    @search = Course.ransack(params[:q])
    @courses = @search.result(distinct: true)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    @reviews = @course.reviews.page(params[:page]).order(cached_votes_score: :desc, cached_votes_up: :desc)
    @current_user = User.find(session["warden.user.user.key"][0][0])
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end


  def upload
    respond_to do |format|
      if @course.update(params.require(:course).permit(:syllabus))
        @course.update(syllabus_uploader: current_user.id)
        format.html { redirect_to @course, notice: 'Syllabus was successfully uploaded.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :show }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, 
        :department_id, :crn, :professor_id, :syllabus, :description)
    end


end
