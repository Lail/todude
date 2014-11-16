json.extract! @project, :id, :name, :color, :updated_since_epoch

json.tasks do
  json.array!(@tasks) do |task|
    json.extract! task, :id, :name, :completed, :project_id
  end
end




