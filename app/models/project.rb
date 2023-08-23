# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  depth        :decimal(10, )
#  height       :decimal(10, )
#  medium       :string(255)
#  name         :string(255)      not null
#  order        :bigint           default(0), not null
#  price        :decimal(10, 2)
#  purchased_at :date
#  purchased_by :string(255)
#  visible      :boolean          default(TRUE), not null
#  width        :decimal(10, )
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  folder_id    :integer          not null
#
# Indexes
#
#  index_projects_on_folder_id     (folder_id)
#  index_projects_on_medium        (medium)
#  index_projects_on_purchased_at  (purchased_at)
#
class Project < ApplicationRecord
  include Archiveable
  include Orderable
  audited

  scope :child_of, ->(folder_id) { where(:folder_id => folder_id) }
  scope :sold, -> { where.not(:purchased_at => nil) }
  scope :not_sold, -> { where(:purchased_at => nil) }
  scope :priced, -> { where.not(:price => nil) }
  scope :not_priced, -> { where(:price => nil) }

  belongs_to :folder
  has_one_attached :photo

  validates_presence_of :name, :folder

  before_validation do |p|
    p.purchased_by = p.purchased_by.presence
    p.folder = Folder.root_folder unless p.folder.present?
    p.price = nil if p.price&.zero?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at folder_id medium name price visible year]
  end

  def self.sizes
    {
      :thumbnail => { :resize_to_fit => [400, 250] },
      :large => { :resize_to_fit => [1200, 1200] }
    }
  end

  def sized_photo(size)
    photo.variant(self.class.sizes[size]).processed if photo.persisted?
  end

  def sold?
    purchased_at.present? || purchased_by.present?
  end

  # override the behavior from Orderable
  def default_order_value
    folder&.projects&.maximum(:order)
  end
end
