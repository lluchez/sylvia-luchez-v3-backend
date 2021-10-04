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
FactoryBot.define do
  factory :folder do
    name { Faker::Mountain.name }

    factory :root_folder do
      root { true }
      sequence(:name) { |i| "Home #{i}" }
    end
  end
end
