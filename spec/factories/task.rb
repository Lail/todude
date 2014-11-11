FactoryGirl.define do  
  factory :task do
    sequence(:name) { |i| "Task numero #{i}" }
    completed false
    project
  end
end
