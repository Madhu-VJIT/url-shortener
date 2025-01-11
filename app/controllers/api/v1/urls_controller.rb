class Api::V1::UrlsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_token
    before_action :set_url, only: [:destroy]
    
    def index
      @urls = Url.all.order(created_at: :desc)
      
      render json: {
        urls: @urls.map { |url| {
          id: url.id,
          long_url: url.long_url,
          short_url: short_url(url.short_url),
          created_at: url.created_at
        }}
      }
    end

    def create
      @url = Url.new(url_params)
      
      if @url.save
        render json: {
          id: @url.id,
          short_url: short_url(@url.short_url),
          long_url: @url.long_url
        }, status: :created
      else
        render json: { errors: @url.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      if @url.destroy
        head :no_content
      else
        render json: { errors: @url.errors }, status: :unprocessable_entity
      end
    end
    
    private
    
    def set_url
      @url = Url.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'URL not found' }, status: :not_found
    end

    def url_params
      params.require(:url).permit(:long_url)
    end
    
    def authenticate_token
      token = request.headers['Authorization']&.split(' ')&.last
      unless valid_token?(token)
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
    
    def valid_token?(token)
      token == ENV['API_TOKEN']
    end
end
