# == Schema Information
#
# Table name: folders
#
#  id               :bigint           not null, primary key
#  from_year        :integer
#  name             :string(255)      not null
#  order            :bigint           default(0), not null
#  root             :boolean
#  to_year          :integer
#  visible          :boolean          default(TRUE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_folder_id :integer
#
# Indexes
#
#  index_folders_on_parent_folder_id  (parent_folder_id)
#  index_folders_on_root              (root) UNIQUE
#
class Folder < ApplicationRecord
  include Archiveable
  include Orderable
  audited

  scope :root, -> { where(:root => true) }
  scope :not_root, -> { where(:root => nil) }
  scope :child_of, ->(parent_id) { where(:parent_folder_id => parent_id) }

  def self.root_folder
    root.last
  end

  has_many :projects, -> { order(:order => :desc, :id => :desc) }
  belongs_to :parent_folder, :class_name => 'Folder', :optional => true
  has_many :sub_folders, -> { order(:order => :desc, :id => :desc) }, :foreign_key => :parent_folder_id, :class_name => 'Folder'

  validates_presence_of :name

  before_validation do |f|
    f.parent_folder_id = Folder.root_folder&.id if f.parent_folder.blank? && !f.root?
  end

  validate :root_attribute_wont_change, :if => proc { |f| f.root_was }
  validate :visible_root_folder, :if => proc { |f| f.root? }

  def root_attribute_wont_change
    errors.add(:root, :cant_change_root) if persisted? && root_changed?
  end

  def visible_root_folder
    errors.add(:visible, :archived_root) if visible_changed? && archived?
  end
end
