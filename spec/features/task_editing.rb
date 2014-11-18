require 'spec_helper'

feature 'Visitor edits Task' do

  let(:existing_project) { build :project }
  let!(:existing_task) { create :task, force_project: existing_project }

  scenario 'updates an existing task', js: true do
    visit root_path

    within(:css, '.tasks') do
      expect(page).to have_content(existing_task.name)   
      click_on 'Edit'
      fill_in 'task_title', with: "New Task Title"
      click_on 'Save'
      wait_for_ajax
      expect(page).to have_content("New Task Title") 
    end

  end  

end
