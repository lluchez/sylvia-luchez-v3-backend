module Api
  module V1
    class ConfigurableTextsController < Api::V1::BaseController
      def show
        @text = ConfigurableText.find_by_code(params[:code]) or raise ActiveRecord::RecordNotFound
      end
    end
  end
end
