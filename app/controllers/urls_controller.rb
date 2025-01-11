class UrlsController < ApplicationController
	def index
    @urls = Url.all.order(created_at: :desc)
  end
  def new
    @url = Url.new
  end
  
  def create
    @url = Url.new(url_params)
    
    if @url.save
      redirect_to @url, notice: 'URL was successfully shortened!'
    else
      render :new
    end
  end
  
  def show
    @url = Url.find(params[:id])
  end

	def destroy
		@url = Url.find(params[:id])
		if @url.destroy
			flash[:notice] = 'URL was successfully deleted.'
		else
			flash[:alert] = 'Error deleting URL.'
		end
		redirect_to urls_path
	rescue ActiveRecord::RecordNotFound
		flash[:alert] = 'URL not found.'
		redirect_to urls_path
	end
  
  def redirect
    url = Url.find_by!(short_url: params[:short_url])
    redirect_to url.long_url, allow_other_host: true
  end
  
  private
  
  def url_params
    params.require(:url).permit(:long_url)
  end
end
