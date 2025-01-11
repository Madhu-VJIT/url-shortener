class Url < ApplicationRecord
	validates :long_url, presence: true
	validates :short_url, presence: true, uniqueness: true
	validate :validate_url_format
	
	before_validation :generate_short_url, on: :create
	
	private
	
	def validate_url_format
	  unless long_url.present? && url_valid?(long_url)
		errors.add(:long_url, "must be a valid URL")
	  end
	end
	
	def url_valid?(url)
	  uri = URI.parse(url)
	  uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
	rescue URI::InvalidURIError
	  false
	end
	
	def generate_short_url
	  self.short_url = SecureRandom.alphanumeric(6)
	  while Url.exists?(short_url: self.short_url)
		self.short_url = SecureRandom.alphanumeric(6)
	  end
	end
end
