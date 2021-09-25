require 'rails_helper'

describe Archiveable do
  let(:factory_name) { :folder }
  let(:model) { Folder }

  describe 'archived?' do
    it 'should return the proper value based on the visible attribute' do
      visible_obj = create(factory_name, :visible => true)
      expect(visible_obj.archived?).to eq(false)

      archived_obj = create(factory_name, :visible => false)
      expect(archived_obj.archived?).to eq(true)
    end
  end

  describe 'scopes' do
    context 'visible/archived' do
      it 'should properly check projects visibility' do
        visible_obj  = create(factory_name, :visible => true)
        archived_obj = create(factory_name, :visible => false)
        expect(model.visible.pluck(:id)).to eq([visible_obj.id])
        expect(model.archived.pluck(:id)).to eq([archived_obj.id])
      end
    end
  end
end
