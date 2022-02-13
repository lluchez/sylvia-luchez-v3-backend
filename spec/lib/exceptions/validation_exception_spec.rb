require 'rails_helper'

describe Exceptions::ValidationException do
  it 'should have accessible properties' do
    e = described_class.new('Message', :field, 'value')
    expect(e.message).to eq("Message")
    expect(e.field).to eq(:field)
    expect(e.value).to eq("value")
  end
end
