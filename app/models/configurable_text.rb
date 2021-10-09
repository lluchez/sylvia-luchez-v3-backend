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
class ConfigurableText < ApplicationRecord
  audited

  FORMATS = %w[html_text].freeze

  FORMATTED_FORMATS = {
    :html_text => 'Customizable Text'.freeze
  }.with_indifferent_access.freeze

  validates_presence_of :name, :code, :format
  validates :format, :inclusion => { :in => FORMATS }, :if => proc { |t| t.format.present? }

  def formatted_format
    FORMATTED_FORMATS[self.format]
  end
end
