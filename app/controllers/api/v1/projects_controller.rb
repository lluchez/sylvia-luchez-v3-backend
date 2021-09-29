module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      def show
        @project = Project.includes(:photo_attachment => :blob).find(params[:id])
      end
    end
  end
end
