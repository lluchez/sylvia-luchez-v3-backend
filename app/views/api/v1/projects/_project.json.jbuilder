# locals: [`project`]
json.extract! project, :id, :name, :visible, :medium, :year
json.url api_v1_project_path(project)

json.dimension do
  json.extract! project, :width, :height, :depth
end

if project.sold?
  json.purchased_information do
    json.extract! project, :purchased_at
    json.purchased_by 'Undisclosed'
  end
end

if project.photo.persisted?
  json.photo do
    json.large do
      json.url url_for(project.sized_photo(:large))
    end
    json.thumb do
      json.url url_for(project.sized_photo(:thumbnail))
    end
  end
end
