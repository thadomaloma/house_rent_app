class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { tenant: 0, owner: 1, admin: 2 }, default: :tenant

  has_many :properties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_properties, through: :favorites, source: :property
  has_many :inquiries, dependent: :nullify

  validates :name, length: { maximum: 80 }
  validates :phone, length: { maximum: 30 }, allow_blank: true

  def owner_or_admin?
    owner? || admin?
  end
end
