class Property < ApplicationRecord
  belongs_to :user
  has_many_attached :photos
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :inquiries, dependent: :destroy

  enum :property_type, {
    house: 0,
    apartment: 1,
    room: 2,
    hostel_pg: 3,
    shop: 4,
    office: 5
  }, default: :house

  enum :area, {
    chanmari: 0,
    dawrpui: 1,
    ramhlun: 2,
    bawngkawn: 3,
    vaivakawn: 4,
    kulikawn: 5,
    durtlang: 6,
    zemabawk: 7,
    thuampui: 8,
    bethlehem: 9,
    mission_veng: 10,
    sihphir: 11,
    other: 12
  }, default: :chanmari

  enum :status, { available: 0, rented: 1, hidden: 2 }, default: :available

  validates :title, :description, :area, :address, :contact_name, :phone, presence: true
  validates :rent, numericality: { greater_than_or_equal_to: 0 }
  validates :deposit, numericality: { greater_than_or_equal_to: 0 }
  validates :bedrooms, :bathrooms, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :acceptable_photos

  scope :visible, -> { where.not(status: :hidden) }
  scope :available_first, -> { order(Arel.sql("CASE WHEN status = 0 THEN 0 ELSE 1 END"), featured: :desc, created_at: :desc) }
  scope :featured, -> { where(featured: true) }
  scope :keyword, ->(term) {
    next all if term.blank?

    normalized = "%#{sanitize_sql_like(term.to_s.strip)}%"
    where("title ILIKE :term OR description ILIKE :term OR address ILIKE :term", term: normalized)
  }
  scope :by_area, ->(value) { value.present? && areas.key?(value) ? where(area: value) : all }
  scope :by_property_type, ->(value) { value.present? && property_types.key?(value) ? where(property_type: value) : all }
  scope :min_rent, ->(value) { value.present? ? where("rent >= ?", value.to_i) : all }
  scope :max_rent, ->(value) { value.present? ? where("rent <= ?", value.to_i) : all }
  scope :with_bedrooms, ->(value) { value.present? ? where("bedrooms >= ?", value.to_i) : all }

  def self.search(filters = {})
    visible
      .keyword(filters[:q])
      .by_area(filters[:area])
      .by_property_type(filters[:property_type])
      .min_rent(filters[:min_rent])
      .max_rent(filters[:max_rent])
      .with_bedrooms(filters[:bedrooms])
      .available_first
  end

  def self.area_options
    areas.keys.map { |key| [ key.humanize.titleize, key ] }
  end

  def self.property_type_options
    property_types.keys.map { |key| [ key.humanize.titleize, key ] }
  end

  def self.status_options
    statuses.keys.map { |key| [ key.humanize.titleize, key ] }
  end

  private

  def acceptable_photos
    photos.each do |photo|
      unless photo.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
        errors.add(:photos, "must be PNG, JPG, JPEG, or WebP")
      end

      if photo.byte_size > 8.megabytes
        errors.add(:photos, "must be smaller than 8 MB")
      end
    end
  end
end
