# http://www.railsstatuscodes.com/
class Api::V1::BaseController < ApplicationController
  before_action :set_default_response_format

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    not_found
  end

  rescue_from Exceptions::ValidationException do |exception|
    invalid(exception)
  end

  protected

  def not_found
    render :json => {
      :message => 'Not found'
    }, :status => :not_found
  end

  def invalid(err)
    render :json => {
      :message => err.message,
      :field => err.field,
      :value => err.value
    }, :status => :unprocessable_entity
  end

  def set_default_response_format
    request.format = :json
  end
end
