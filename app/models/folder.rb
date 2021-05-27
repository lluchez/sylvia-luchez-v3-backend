# == Schema Information
#
# Table name: folders
#
#  id               :bigint           not null, primary key
#  from_year        :integer
#  name             :string(255)      not null
#  to_year          :integer
#  visible          :boolean          default(TRUE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_folder_id :integer
#
# Indexes
#
#  index_folders_on_parent_folder_id  (parent_folder_id)
#
class Folder < ApplicationRecord
  audited

  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }
  scope :root, -> { where(:parent_folder_id => nil) }
  scope :child_of, ->(parent_id) { where(:parent_folder_id => parent_id) }

  has_many :projects
  belongs_to :parent_folder, :class_name => 'Folder', :optional => true
  has_many :sub_folders, :foreign_key => :parent_folder_id, :class_name => 'Folder'

  validates_presence_of :name
end
