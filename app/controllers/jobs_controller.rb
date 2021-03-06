class JobsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_job_and_check_permission , only: [:edit, :update, :destroy]

  def index
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC')
            when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC')
            else
              Job.published.recent
            end
  end
  
  def show
  	@job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "This Job already archived"
      redirect_to root_path
    end
  end

  def new
  	@job = Job.new
  end

  def create
  	@job = Job.new(job_params)
    @job.user = current_user
  	if @job.save
      redirect_to jobs_path
    else
      render :new
  	end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
  	@job.destroy
  	flash[:alert] = "Group deleted"
  	redirect_to jobs_path
  end

  private

  def job_params
  	params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end

  def find_job_and_check_permission
    @job = Job.find(params[:id])
    return if current_user.admin?

    if current_user != @job.user
        redirect_to root_path, alert: "You have no permission."
    end
  end

end
