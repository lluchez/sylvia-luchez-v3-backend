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
      purchased_at { Faker::Date.between(:from => 5.years.ago, :to => Date.today) }
      purchased_by { Faker::Name }
    end
  end
end
