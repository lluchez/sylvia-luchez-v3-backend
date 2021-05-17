# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  depth        :decimal(10, )
#  height       :decimal(10, )
#  medium       :string(255)
#  name         :string(255)      not null
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
  audited

  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }
  scope :child_of, ->(folder_id) { where(:folder_id => folder_id) }
  scope :sold, -> { where.not(:purchased_at => nil) }
  scope :not_sold, -> { where(:purchased_at => nil) }

  belongs_to :folder

  before_validation do |p|
    p.purchased_by = p.purchased_by.presence
  end

  def sold?
    purchased_at.present?
  end
end
