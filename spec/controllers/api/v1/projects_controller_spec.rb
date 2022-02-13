require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, :type => :controller do
  render_views

  describe "GET #show" do
    context 'for an non existing project' do
      it "should return a 404 response" do
        get :show, :params => { :id => 99_999 }, :format => :json
        expect(response.status).to eq(404)

        data = JSON.parse(response.body)
        expect(data['message']).to eq('Not found')
      end

      it "should return a 404 response" do
        get :show, :params => { :id => 99_999 }
        expect(response.status).to eq(404)

        expect(response.body).to eq('')
      end
    end

    context 'for an existing project' do
      it "it should return all serialized attributes" do
        project = create(:project, {
          :name => 'Test Project',
          :visible => true,
          :medium => 'Photography',
          :year => 2010,
          :width => 10,
          :height => 20,
          :depth => 5
        })
        get :show, :params => { :id => project.id }, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['project']
        dim = data['dimension']
        sold = data['purchased_information']
        expect(data['id']).to eq(project.id)
        expect(data['name']).to eq('Test Project')
        expect(data['visible']).to eq(true)
        expect(data['medium']).to eq('Photography')
        expect(data['year']).to eq(2010)
        expect(data['url']).to eq("/api/v1/projects/#{project.id}")
        expect(dim['width']).to eq(10)
        expect(dim['height']).to eq(20)
        expect(dim['depth']).to eq(5)
        expect(sold).to eq(nil)

        project.update!(
          :purchased_by => 'Foo',
          :purchased_at => Date.new(2011, 1, 30)
        )

        get :show, :params => { :id => project.id }, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['project']
        sold = data['purchased_information']
        expect(sold['purchased_by']).to eq('Undisclosed')
        expect(sold['purchased_at']).to eq('2011-01-30')
      end
    end
  end
end
