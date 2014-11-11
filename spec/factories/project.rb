FactoryGirl.define do
  factory :project do
    name "My lovely project"
    color  Project::COLORS.sample
  end
end
