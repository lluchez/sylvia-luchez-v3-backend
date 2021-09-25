require 'rails_helper'

describe Project do
  describe 'relationships' do
    it { should belong_to(:folder) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:folder) }
  end

  describe 'audited' do
    before(:each) { described_class.auditing_enabled = true }
    after(:each) { described_class.auditing_enabled = true }

    it { should be_audited }
  end

  describe 'scopes' do
    context 'visible/archived' do
      it 'should properly check projects visibility' do
        project1 = create(:project)
        project2 = create(:project, :visible => false)
        expect(described_class.visible.pluck(:id)).to eq([project1.id])
        expect(described_class.archived.pluck(:id)).to eq([project2.id])
      end
    end

    context 'child_of' do
      it 'should properly check if a project belongs to a given folder' do
        folder = create(:folder)
        project1 = create(:project)
        project2 = create(:project)
        expect(described_class.child_of(folder.id).pluck(:id)).to eq([])
        expect(described_class.child_of(project1.folder_id).pluck(:id)).to eq([project1.id])
        expect(described_class.child_of(project2.folder_id).pluck(:id)).to eq([project2.id])
      end
    end

    context 'sold/not_sold' do
      it 'should properly check if a project was sold or not' do
        project1 = create(:project)
        project2 = create(:project, :sold)
        expect(described_class.not_sold.pluck(:id)).to eq([project1.id])
        expect(described_class.sold.pluck(:id)).to eq([project2.id])
      end
    end
  end
end
