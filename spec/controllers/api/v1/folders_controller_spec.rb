require 'rails_helper'

RSpec.describe Api::V1::FoldersController, :type => :controller do
  render_views

  describe "GET #show" do
    context 'for an non existing folder' do
      it "should return a 404 response" do
        get :show, :params => { :id => 99_999 }, :format => :json
        expect(response.status).to eq(404)

        data = JSON.parse(response.body)
        expect(data['error']).to eq('not_found')
      end
    end

    context 'for an existing folder' do
      it "it should return all serialized attributes" do
        root_folder = create(:root_folder, {
          :name => 'Home Folder',
          :visible => true,
          :from_year => 2001,
          :to_year => 2019
        })
        project = create(:project, {
          :name => 'Test Project',
          :visible => true,
          :folder => root_folder
        })
        create(:folder, {
          :name => 'Hidden Sub Folder',
          :visible => false,
          :parent_folder => root_folder
        })
        sub_folder = create(:folder, {
          :name => 'Sub Folder',
          :visible => true,
          :from_year => 2003,
          :to_year => 2020,
          :parent_folder => root_folder
        })
        sub_sub_folder = create(:folder, {
          :name => 'Sub Sub Folder',
          :visible => true,
          :parent_folder => sub_folder
        })
        create(:project, {
          :name => 'Hidden Sub Project',
          :visible => false,
          :folder => sub_folder
        })

        # querying the root folder
        get :show, :params => { :id => root_folder.id }, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['folder']
        sub_folders = data['sub_folders']
        par_folders = data['parent_folder']
        projects = data['projects']
        expect(data['id']).to eq(root_folder.id)
        expect(data['name']).to eq('Home Folder')
        expect(data['visible']).to eq(true)
        expect(data['from_year']).to eq(2001)
        expect(data['to_year']).to eq(2019)
        expect(data['url']).to eq("/api/v1/folders/#{root_folder.id}")
        expect(data['root']).to eq(true)
        expect(par_folders).to eq(nil)
        expect(sub_folders.class).to eq(Array)
        expect(sub_folders.count).to eq(1)
        expect(sub_folders.first['folder']['id']).to eq(sub_folder.id)
        expect(sub_folders.first['folder']['name']).to eq('Sub Folder')
        expect(sub_folders.first['folder']['sub_folders']).to eq(nil)
        expect(projects.class).to eq(Array)
        expect(projects.count).to eq(1)
        expect(projects.first['project']['id']).to eq(project.id)
        expect(projects.first['project']['name']).to eq('Test Project')

        # querying the sub folder
        get :show, :params => { :id => sub_folder.id }, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['folder']
        sub_folders = data['sub_folders']
        par_folders = data['parent_folder']
        projects = data['projects']
        expect(data['id']).to eq(sub_folder.id)
        expect(data['name']).to eq('Sub Folder')
        expect(data['visible']).to eq(true)
        expect(data['from_year']).to eq(2003)
        expect(data['to_year']).to eq(2020)
        expect(data['url']).to eq("/api/v1/folders/#{sub_folder.id}")
        expect(data['root']).to eq(nil)
        expect(par_folders['id']).to eq(root_folder.id)
        expect(par_folders['url']).to eq("/api/v1/folders/#{root_folder.id}")
        expect(sub_folders.class).to eq(Array)
        expect(sub_folders.count).to eq(1)
        expect(sub_folders.first['folder']['id']).to eq(sub_sub_folder.id)
        expect(sub_folders.first['folder']['name']).to eq('Sub Sub Folder')
        expect(sub_folders.first['folder']['sub_folders']).to eq(nil)
        expect(projects.class).to eq(Array)
        expect(projects.count).to eq(0)
      end
    end
  end

  describe "GET #root" do
    context 'for an non existing root folder' do
      it "should return a 404 response" do
        get :root, :format => :json
        expect(response.status).to eq(404)

        data = JSON.parse(response.body)
        expect(data['error']).to eq('not_found')
      end
    end

    context 'for an existing root folder' do
      it "it should return all serialized attributes" do
        root_folder = create(:root_folder, {
          :name => 'Home Folder',
          :visible => true,
          :from_year => 2001,
          :to_year => 2019
        })
        project = create(:project, {
          :name => 'Test Project',
          :visible => true,
          :folder => root_folder
        })
        create(:folder, {
          :name => 'Hidden Sub Folder',
          :visible => false,
          :parent_folder => root_folder
        })
        sub_folder = create(:folder, {
          :name => 'Sub Folder',
          :visible => true,
          :from_year => 2003,
          :to_year => 2020,
          :parent_folder => root_folder
        })

        # querying the root folder
        get :root, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['folder']
        sub_folders = data['sub_folders']
        par_folders = data['parent_folder']
        projects = data['projects']
        expect(data['id']).to eq(root_folder.id)
        expect(data['name']).to eq('Home Folder')
        expect(data['visible']).to eq(true)
        expect(data['from_year']).to eq(2001)
        expect(data['to_year']).to eq(2019)
        expect(data['url']).to eq("/api/v1/folders/#{root_folder.id}")
        expect(data['root']).to eq(true)
        expect(par_folders).to eq(nil)
        expect(sub_folders.class).to eq(Array)
        expect(sub_folders.count).to eq(1)
        expect(sub_folders.first['folder']['id']).to eq(sub_folder.id)
        expect(sub_folders.first['folder']['name']).to eq('Sub Folder')
        expect(sub_folders.first['folder']['sub_folders']).to eq(nil)
        expect(projects.class).to eq(Array)
        expect(projects.count).to eq(1)
        expect(projects.first['project']['id']).to eq(project.id)
        expect(projects.first['project']['name']).to eq('Test Project')
      end
    end
  end
end
