Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins DynamicConfig.cors_origins
    resource '/api/*', :headers => :any, :methods => [:options, :get, :post]
  end
end
