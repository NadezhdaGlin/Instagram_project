class Post < ApplicationRecord
	mount_uploader :image, ImageUploader
	validates :description, :image, presence: true
	has_many :comments, dependent: :destroy

end