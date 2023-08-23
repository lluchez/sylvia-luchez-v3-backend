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
require 'rails_helper'

describe ConfigurableText do
  describe 'audited' do
    before(:each) { described_class.auditing_enabled = true }
    after(:each) { described_class.auditing_enabled = true }

    it { should be_audited }
  end

  describe '#validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:format) }
    it { should allow_value('html_text').for(:format) }
    it { should_not allow_value('random').for(:format) }
  end

  describe 'formatted_format' do
    it 'should return the formatted value for a given code' do
      expect(ConfigurableText.new(:format => 'html_text').formatted_format).to eq('Customizable Text')
      expect(ConfigurableText.new(:format => :html_text).formatted_format).to eq('Customizable Text')
      expect(ConfigurableText.new(:format => :abc).formatted_format).to eq(nil)
    end
  end

  describe 'ransackable_attributes' do
    it 'spec coverage' do
      expect(described_class.ransackable_attributes.class).to eq(Array)
    end
  end
end
