require 'rails_helper'

RSpec.describe "Tasks", :type => :request do

  it "returns a single Task" do
    task = create :task
    get "/projects/#{task.project.id}/tasks/#{task.id}", format: :json
    expect(response).to be_success
    expect(json['name']).to eq(task.name)
  end

  it "creates a Task" do
    task = build :task
    params = { name: task.name, completed: false }
    post "/projects/#{task.project.id}/tasks", format: :json, task: params
    expect(response).to be_success
    expect(json['name']).to eq(task.name)
  end 

  it "renders errors on failed :create" do
    task = build :task
    params = { name: task.name, completed: nil }
    post "/projects/#{task.project.id}/tasks", format: :json, task: params
    expect(response).not_to be_success
    expect(json['completed']).to eq(["must be set"])
  end

  it "updates a Task" do
    task = create :task
    params = { name: "New name" }
    patch "/projects/#{task.project.id}/tasks/#{task.id}", format: :json, task: params
    expect(response).to be_success
    expect(json['name']).to eq("New name")
  end

  it "renders errors on failed :update" do
    task = create :task
    params = { completed: nil }
    patch "/projects/#{task.project.id}/tasks/#{task.id}", format: :json, task: params
    expect(response).not_to be_success
    expect(json['completed']).to eq(["must be set"])
  end

  it "deletes a Task" do
    task = create :task
    delete "/projects/#{task.project.id}/tasks/#{task.id}", format: :json
    expect(response).to be_success
  end

end
