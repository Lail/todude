require "rails_helper"

RSpec.describe Project, :type => :model do
  it "can create a valid instance" do
    my_project = Project.create!(name: "My first project", color: Project::COLORS.sample)
    expect(my_project).to be_valid
  end

  # Validations
  it "requires a name" do
    my_project = Project.create(name: nil, color: Project::COLORS.sample)
    expect(my_project).to be_invalid
  end

  it "requires a name with a reasonable length" do
    too_long = 'X' * 501
    my_project = Project.create(name: too_long, color: Project::COLORS.sample)
    expect(my_project).to be_invalid
  end

  it "requires a color" do
    my_project = Project.create(name: "My first project", color: nil)
    expect(my_project).to be_invalid
  end

  it "requires a valid color" do
    my_project = Project.create(name: "My first project", color: "000000")
    expect(my_project).to be_invalid
  end

end
