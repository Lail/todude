require 'rails_helper'

RSpec.describe Task, :type => :model do
  it "can create a valid instance" do
    task = create :task
    expect(task).to be_valid
  end

  # Validations
  it "requires a name" do
    task = build :task, name: nil
    expect(task).to be_invalid
  end

  it "requires a name with a reasonable length" do
    too_long = 'X' * 501
    task = build :task, name: too_long
    expect(task).to be_invalid
  end

  it "requires a completed value" do
    task = build :task, completed: nil
    expect(task).to be_invalid
  end

  it "requires a project" do
    task = build :task, project: nil
    expect(task).to be_invalid
  end


end
