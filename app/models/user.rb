class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :recoverable

  # :validatable убран из основного списка devise

  # :validatable пришлось отключить из-за ошибки c email. Предположительно это баг.
  # Никто не создает devise без поля email

  # -> Валидации заменяющие :validatable
  validates :login, presence: true, length: { in: 1..20 }, uniqueness: true
  validates :password, confirmation: true, length: { in: 6..20 }
  validates :password_confirmation, presence: true
  # <-

  has_many :cards, dependent: :destroy
end
