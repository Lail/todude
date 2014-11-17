require "rails_helper"

RSpec.describe Project, :type => :model do
  it "can create a valid instance" do
  	project = create :project
    expect(project).to be_valid
  end

  # Validations
  it "requires a name" do
    project = build :project, name: nil
    expect(project).to be_invalid
  end

  it "requires a name with a reasonable length" do
    too_long = 'X' * 501
    project = build :project, name: too_long
    expect(project).to be_invalid
  end

  it "requires a color" do
    project = build :project, color: nil
    expect(project).to be_invalid
  end

  it "requires a valid color" do
    project = build :project, color: "NO GOOD"
    expect(project).to be_invalid
  end

end
