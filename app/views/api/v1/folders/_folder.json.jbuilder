# locals: [`folder`]
json.extract! folder, :id, :name, :visible, :from_year, :to_year
json.url api_v1_folder_path(folder)

if folder.root?
  json.extract! folder, :root
else
  json.parent_folder do
    json.id folder.parent_folder_id
    json.url api_v1_folder_path(folder.parent_folder_id)
  end
end

if folder.association(:sub_folders).loaded?
  json.sub_folders do
    json.array! folder.sub_folders do |sub_folder|
      if sub_folder.visible?
        json.folder do
          json.partial! "api/v1/folders/folder", :folder => sub_folder
        end
      end
    end
  end
end

if folder.association(:projects).loaded?
  json.projects do
    json.array! folder.projects do |project|
      if project.visible?
        json.project do
          json.partial! "api/v1/projects/project", :project => project
        end
      end
    end
  end
end
