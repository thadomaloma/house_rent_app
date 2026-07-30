class Inquiry < ApplicationRecord
  belongs_to :property
  belongs_to :user, optional: true

  validates :name, :phone, :message, presence: true
  validates :message, length: { maximum: 1_000 }
end
