class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :validatable
  devise :database_authenticatable, :registerable, :rememberable, :trackable

  validates :login, presence: true, length: { in: 1..20 }, uniqueness: true
  validates :password, confirmation: true, length: { in: 6..20 }
  validates :password_confirmation, presence: true

  has_many :cards, dependent: :destroy
end
