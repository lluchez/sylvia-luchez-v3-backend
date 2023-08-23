# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  depth        :decimal(10, )
#  height       :decimal(10, )
#  medium       :string(255)
#  name         :string(255)      not null
#  order        :bigint           default(0), not null
#  price        :decimal(10, 2)
#  purchased_at :date
#  purchased_by :string(255)
#  visible      :boolean          default(TRUE), not null
#  width        :decimal(10, )
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  folder_id    :integer          not null
#
# Indexes
#
#  index_projects_on_folder_id     (folder_id)
#  index_projects_on_medium        (medium)
#  index_projects_on_purchased_at  (purchased_at)
#
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

  describe '#sold?' do
    context 'when purchased date is set' do
      it 'should return true' do
        expect(create(:project, :purchased_at => Date.today).sold?).to eq(true)
      end
    end

    context 'when purchased date is not set' do
      it 'should return false' do
        expect(create(:project, :purchased_at => nil).sold?).to eq(false)
      end
    end
  end

  describe '#validation' do
    context 'when purchased by is a blank text' do
      it 'should nil it' do
        project = create(:project, :purchased_by => '')
        expect(project.purchased_by).to eq(nil)

        project = build(:project, :purchased_by => '')
        expect(project.valid?).to eq(true)
        expect(project.purchased_by).to eq(nil)
      end
    end

    context 'when folder is blank' do
      it 'should create under the root folder' do
        root_folder = create(:root_folder)
        project = create(:project, :folder => nil)
        expect(project.folder).to eq(root_folder)

        project = build(:project, :folder => nil)
        expect(project.valid?).to eq(true)
        expect(project.folder).to eq(root_folder)
      end

      it 'should keep the assigned folder if set' do
        create(:root_folder)
        other_folder = create(:folder)
        project = create(:project, :folder => other_folder)
        expect(project.folder).to eq(other_folder)

        project = build(:project, :folder => other_folder)
        expect(project.valid?).to eq(true)
        expect(project.folder).to eq(other_folder)
      end
    end
  end

  describe '#default_order_value' do
    context 'project is assigned' do
      it 'should predict the correct value for `order` based on other projects within this folder' do
        root_folder = create(:root_folder)

        other_folder = create(:folder, :parent_folder => root_folder)
        expect(create(:project, :folder => other_folder, :order => 99).order).to eq(99)

        expect(create(:project, :folder => root_folder, :order => nil).order).to eq(1)
        expect(create(:project, :folder => root_folder, :order => nil).order).to eq(2)
        expect(create(:project, :folder => root_folder, :order => 8).order).to eq(8)
        expect(create(:project, :folder => root_folder, :order => nil).order).to eq(9)
        expect(create(:project, :folder => root_folder, :order => 3).order).to eq(3)
      end
    end

    context 'project is not assigned' do
      it 'should look at the root folder' do
        root_folder = create(:root_folder)
        other_folder = create(:folder, :parent_folder => root_folder)
        create(:project, :folder => root_folder, :order => 10)
        create(:project, :folder => other_folder, :order => 12)

        project = create(:project, :folder => nil, :order => nil)
        expect(project.folder).to eq(root_folder)
        expect(project.order).to eq(11)
      end
    end
  end

  describe 'ransackable_attributes' do
    it 'spec coverage' do
      expect(described_class.ransackable_attributes.class).to eq(Array)
    end
  end
end
