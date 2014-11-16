json.extract! @project, :id, :name, :color, :updated_since_epoch do

  json.array!(@tasks) do |task|
    json.extract! task, :id, :name, :completed
  end

end

