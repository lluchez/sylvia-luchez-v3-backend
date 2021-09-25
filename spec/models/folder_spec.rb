require 'rails_helper'

describe Folder do
  describe 'relationships' do
    it { should have_many(:projects) }
    it { should have_many(:sub_folders) }
    it { should belong_to(:parent_folder).without_validating_presence }

    it { should validate_presence_of(:name) }
  end

  describe 'audited' do
    before(:each) { described_class.auditing_enabled = true }
    after(:each) { described_class.auditing_enabled = true }

    it { should be_audited }
  end

  describe 'scopes' do
    context 'visible/archived' do
      it 'should properly check folders visibility' do
        folder1 = create(:folder)
        folder2 = create(:folder, :visible => false)
        expect(described_class.visible.pluck(:id)).to eq([folder1.id])
        expect(described_class.archived.pluck(:id)).to eq([folder2.id])
      end
    end

    context 'root/child_of' do
      it 'should properly check ancestor folders' do
        folder1 = create(:folder)
        folder2 = create(:folder, :parent_folder => folder1)
        folder3 = create(:folder, :parent_folder => folder2)
        expect(described_class.root.pluck(:id)).to eq([folder1.id])
        expect(described_class.child_of(nil).pluck(:id)).to eq([folder1.id])
        expect(described_class.child_of(folder1.id).pluck(:id)).to eq([folder2.id])
        expect(described_class.child_of(folder2.id).pluck(:id)).to eq([folder3.id])
      end
    end
  end
end
