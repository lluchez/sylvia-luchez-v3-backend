require 'rails_helper'

describe Orderable do
  let(:factory_name) { :folder }
  let(:model) { Folder }

  describe '#set_order_default_value' do
    it 'should assign the proper value based on the higher count' do
      root_folder = create(:root_folder, :order => nil)
      expect(root_folder.order).to eq(1)

      obj = create(factory_name, :order => '')
      expect(obj.order).to eq(2)

      obj2 = create(factory_name, :order => 6)
      expect(obj2.order).to eq(6)
    end
  end
end
