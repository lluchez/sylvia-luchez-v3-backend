module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        not_found
      end

      protected

      def not_found
        respond_to do |format|
          format.json { render :json => { :error => 'not_found' }, :status => :not_found }
          format.any  { head :not_found, :status => :not_found }
        end
      end
    end
  end
end
