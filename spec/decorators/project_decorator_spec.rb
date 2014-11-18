require 'spec_helper'

RSpec.describe ProjectDecorator, :type => :model do	

  it "can decorate an instance" do
    project = create :project
    expect(project.decorate).to be_decorated
  end

  it "can return updated_since_epoch" do
    project = create :project
    milliseconds = project.updated_at.to_i * 1000
    expect(project.decorate.updated_since_epoch).to eq(milliseconds)
  end

end
