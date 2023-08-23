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

    context 'root/not_root/child_of' do
      it 'should properly check ancestor folders' do
        root_folder = create(:root_folder)
        folder2 = create(:folder, :parent_folder => root_folder)
        folder3 = create(:folder, :parent_folder => folder2)
        expect(described_class.root.pluck(:id)).to eq([root_folder.id])
        expect(described_class.not_root.pluck(:id)).to eq([folder2.id, folder3.id])
        expect(described_class.child_of(nil).pluck(:id)).to eq([root_folder.id])
        expect(described_class.child_of(root_folder.id).pluck(:id)).to eq([folder2.id])
        expect(described_class.child_of(folder2.id).pluck(:id)).to eq([folder3.id])
      end
    end
  end

  describe '#validation' do
    context 'when parent folder is missing' do
      it 'should mark as child of the root folder' do
        root_folder = create(:root_folder)
        folder = create(:folder)
        expect(folder.parent_folder).to eq(root_folder)
      end
    end

    context '#root_attribute_wont_change' do
      it 'should prevent updating the root attribute' do
        root_folder = create(:root_folder)
        root_folder.root = false
        expect(root_folder.valid?).to eq(false)
        expect(root_folder.errors.attribute_names).to eq([:root])
        expect(root_folder.errors.full_messages).to eq(['Root Cannot unmark the root folder'])
      end

      it 'should prevent to create a root folder' do
        root_folder = create(:root_folder)
        expect(root_folder.root).to eq(true)
      end
    end

    context '#visible_root_folder' do
      it 'should prevent to archive the root folder' do
        root_folder = create(:root_folder)
        root_folder.visible = false
        expect(root_folder.valid?).to eq(false)
        expect(root_folder.errors.attribute_names).to eq([:visible])
        expect(root_folder.errors.full_messages).to eq(['Visible Cannot archive the root folder'])
      end
    end
  end

  describe 'ransackable_attributes' do
    it 'spec coverage' do
      expect(described_class.ransackable_attributes.class).to eq(Array)
    end
  end
end
