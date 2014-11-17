require 'rails_helper'

RSpec.describe "Projects", :type => :request do

  it "returns a list of Projects" do
    5.times { create :project }
    get "/projects", format: :json
    expect(response).to be_success
    expect(json.count).to eq(5)
  end

  it "returns a single Project" do
    project = create :project
    get "/projects/#{project.id}", format: :json
    expect(response).to be_success
    expect(json['name']).to eq(project.name)
  end

  it "creates a Project" do
    project = build :project
    params = { name: project.name, color: project.color }
    post "/projects", format: :json, project: params
    expect(response).to be_success
    expect(json['name']).to eq(project.name)
  end 

  it "renders errors on failed :create" do
    project = build :project
    params = { name: project.name, color: "NO GOOD" }
    post "/projects", format: :json, project: params
    expect(response).not_to be_success
    expect(json['color']).to eq(["not a valid hex color"])
  end

  it "updates a Project" do
    project = create :project
    params = { name: "New name" }
    patch "/projects/#{project.id}", format: :json, project: params
    expect(response).to be_success
    expect(json['name']).to eq("New name")
  end

  it "renders errors on failed :update" do
    project = create :project
    params = { color: "NO GOOD" }
    patch "/projects/#{project.id}", format: :json, project: params
    expect(response).not_to be_success
    expect(json['color']).to eq(["not a valid hex color"])
  end

  it "deletes a Project" do
    project = create :project
    delete "/projects/#{project.id}", format: :json
    expect(response).to be_success
  end

end
