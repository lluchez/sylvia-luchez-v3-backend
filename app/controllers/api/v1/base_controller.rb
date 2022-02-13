# http://www.railsstatuscodes.com/
class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    not_found
  end

  rescue_from Exceptions::ValidationException do |exception|
    invalid(exception)
  end

  protected

  def not_found
    respond_to do |format|
      format.json do
        render :json => {
          :message => 'Not found'
        }, :status => :not_found
      end
      format.any do
        head :not_found, :status => :not_found
      end
    end
  end

  def invalid(err)
    respond_to do |format|
      format.json do
        render :json => {
          :message => err.message,
          :field => err.field,
          :value => err.value
        }, :status => :unprocessable_entity
      end
      format.any do
        render :plain => "#{err.message}\nField: #{err.field}\nValue: #{err.value}", :status => :unprocessable_entity
      end
    end
  end
end
