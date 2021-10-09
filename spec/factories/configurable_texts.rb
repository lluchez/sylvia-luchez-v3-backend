# == Schema Information
#
# Table name: configurable_texts
#
#  id         :bigint           not null, primary key
#  code       :string(255)      not null
#  format     :string(255)      default("text"), not null
#  name       :string(255)      not null
#  value      :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_configurable_texts_on_code    (code) UNIQUE
#  index_configurable_texts_on_format  (format)
#  index_configurable_texts_on_name    (name) UNIQUE
#
FactoryBot.define do
  factory :configurable_text do
    sequence(:name) { |i| "Text #{i}" }
    sequence(:code) { |i| "text_#{i}" }
    format { 'html_text' }
    sequence(:value) { |i| "<p>HTML Text #{i}" }
  end
end
