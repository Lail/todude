require 'spec_helper'

feature 'Visitor deletes Task' do

  let(:existing_project) { build :project }
  let!(:existing_task) { create :task, force_project: existing_project }

  scenario 'removes an existing task', js: true do
    visit root_path

    within(:css, '.tasks') do
      expect(page).to have_content(existing_task.name)   
      click_on 'Delete'
      wait_for_ajax
      expect(page).not_to have_content(existing_task.name) 
    end

  end  

end
