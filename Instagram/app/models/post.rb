# frozen_string_literal: true

class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :description, :image, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user
end
