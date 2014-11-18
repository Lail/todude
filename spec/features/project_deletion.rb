require 'spec_helper'

feature 'Visitor deletes a Project' do

  let!(:existing_project) { create :project }

  scenario 'deleting existing project', js: true do
    visit root_path

    within(:css, 'aside') do
      expect(page).to have_content(existing_project.name)   
    end  

    within(:css, '.project') do
      expect(page).to have_content(existing_project.name)  
      click_on 'Delete'
    end

    wait_for_ajax

    within(:css, '.project') do
      expect(page).not_to have_content(existing_project.name)   
    end
    within(:css, 'aside') do
      expect(page).not_to have_content(existing_project.name)   
    end    
  end  

end
