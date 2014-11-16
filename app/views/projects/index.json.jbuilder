json.array!(@projects) do |project|
  json.extract! project, :id, :name, :color, :updated_since_epoch
end
