require 'rails_helper'

describe ActiveAdminHelper do
  describe '#folder_collection' do
    it 'should return an array with the correct data' do
      root_folder = create(:root_folder)
      res = described_class.folder_collection
      expect(res).to eq([[root_folder.name, root_folder.id]])

      folder1 = create(:folder, :name => 'Abc')
      folder2 = create(:folder, :name => 'Zyx')
      res = described_class.folder_collection
      expect(res).to eq([
        [folder1.name, folder1.id],
        [root_folder.name, root_folder.id],
        [folder2.name, folder2.id]
      ])
    end
  end

  describe '#model_collection' do
    it 'should apply a formatter if given' do
      root_folder = create(:root_folder)

      res = described_class.model_collection(Folder, formatter: :upcase)
      expect(res).to eq([
        [root_folder.name.upcase, root_folder.id]
      ])
    end

    it 'should apply the block if given' do
      root_folder = create(:root_folder)

      res = described_class.model_collection(Folder){ |f| f.id + 5 }
      expect(res).to eq([
        [root_folder.id + 5, root_folder.id]
      ])
    end

    it 'should add the extra option if given' do
      extra_option = { :text => 'None', :value => 0 }
      expected_extra_option = ['None', 0]
      res = described_class.model_collection(Folder, :extra_option => extra_option)
      expect(res).to eq([expected_extra_option])

      root_folder = create(:root_folder)
      res = described_class.model_collection(Folder, :extra_option => extra_option)
      expect(res).to eq([expected_extra_option] + [[root_folder.name, root_folder.id]])
    end
  end

  describe '#unique_field_collection' do
    it 'should return a list of unique value for that given attribute' do
      root_folder = create(:root_folder)
      folder1 = create(:folder, :parent_folder => root_folder)
      folder1 = create(:folder, :parent_folder => root_folder)

      expect(described_class.unique_field_collection(Folder, :parent_folder_id) { |f| 'A' }).to eq(
        [['A', nil], ['A', root_folder.id]]
      )
      expect(described_class.unique_field_collection(Folder.where('parent_folder_id IS NOT NULL'), :parent_folder_id)).to eq(
        [[root_folder.id, root_folder.id]]
      )
    end
  end

  describe '#generate_id_union_query' do
    it '' do
      root_folder = create(:root_folder, :name => 'Foo')
      folder1 = create(:folder, :parent_folder => root_folder)
      folder2 = create(:folder, :parent_folder => folder1)

      # without any ID
      expect(described_class.generate_id_union_query(Folder.root, nil, :name).select('*').map(&:id)).to eq([root_folder.id])

      # using the object
      expect(described_class.generate_id_union_query(Folder.root, folder1, :name).select('*').map(&:id)).to eq([root_folder.id, folder1.id])

      # using an ID
      expect(described_class.generate_id_union_query(Folder.root, folder1.id, :name).select('*').map(&:id)).to eq([root_folder.id, folder1.id])

      # using multiple IDs
      expect(described_class.generate_id_union_query(Folder.root, [folder1.id, folder2.id], :name).select('*').map(&:id)).to eq([root_folder.id, folder1.id, folder2.id])
    end
  end
end
