FactoryGirl.define do  
  factory :task do
    sequence(:name) { |i| "Task numero #{i}" }
    completed false
    project

    transient do
      force_project false
    end
  end
end
