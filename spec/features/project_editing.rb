require 'spec_helper'

feature 'Visitor edits a Project' do

  let!(:existing_project) { create :project }

  scenario 'updating title', js: true do
    visit root_path

    within(:css, 'aside') do
      expect(page).to have_content(existing_project.name)   
    end  

    within(:css, '.project') do
      expect(page).to have_content(existing_project.name)  
      click_on 'Edit'
      fill_in 'project_title', with: "My New Title"
      click_on 'Save'
    end

    wait_for_ajax

    within(:css, '.project') do
      expect(page).to have_content("My New Title")   
    end
    within(:css, 'aside') do
      expect(page).to have_content("My New Title")   
    end    
  end  

end
