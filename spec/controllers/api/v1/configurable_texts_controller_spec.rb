require 'rails_helper'

RSpec.describe Api::V1::ConfigurableTextsController, :type => :controller do
  render_views

  describe "GET #show" do
    context 'for an non existing text' do
      it "should return a 404 response" do
        get :show, :params => { :code => 'abc' }, :format => :json
        expect(response.status).to eq(404)

        data = JSON.parse(response.body)
        expect(data['error']).to eq('not_found')
      end
    end

    context 'for an existing text' do
      it "it should return all serialized attributes" do
        text = create(:configurable_text, {
          :name => 'My Awesome Text',
          :code => 'my_awesome_text',
          :value => 'Content of My Awesome Text'
        })

        # querying the text
        get :show, :params => { :code => text.code }, :format => :json
        expect(response).to be_successful

        data = JSON.parse(response.body)['text']
        expect(data['id']).to eq(text.id)
        expect(data['name']).to eq('My Awesome Text')
        expect(data['code']).to eq('my_awesome_text')
        expect(data['value']).to eq('Content of My Awesome Text')
      end
    end
  end
end
