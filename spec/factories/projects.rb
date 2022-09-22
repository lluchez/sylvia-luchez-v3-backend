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
FactoryBot.define do
  factory :project do
    name { Faker::Mountain.name }
    folder
    medium { ['Oil on Canvas', 'Acrylic on Canvas', 'Mixed Medium'].sample }
    year { Faker::Number.within(:range => 2000..Time.now.year) }
    width { Faker::Number.within(:range => 10..20) }
    height { Faker::Number.within(:range => 10..20) }
    depth { nil }

    trait :sold do
      purchased_at { Faker::Date.backward(:days => 15) }
      purchased_by { Faker::Name }
    end
  end
end
