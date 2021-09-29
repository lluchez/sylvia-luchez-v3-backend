module Api
  module V1
    class FoldersController < Api::V1::BaseController
      def show
        @folder = folder_base_query.find(params[:id])
      end

      def root
        @folder = folder_base_query.root_folder or raise ActiveRecord::RecordNotFound
      end

      private

      def folder_base_query
        Folder.includes(:sub_folders, :projects => { :photo_attachment => :blob })
      end
    end
  end
end
