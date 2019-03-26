class User < ApplicationRecord

  has_many :books
  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :full_name, presence: true
  validates :avatar, :presence => true #required to upload profile pic
  
  mount_uploader :avatar, AvatarUploader       
end
