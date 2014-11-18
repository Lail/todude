require 'spec_helper'

feature 'Visitor creates Project' do

  scenario 'adds two projects', js: true do
    visit root_path

    within(:css, '.project') do
      fill_in 'project_title', with: "My First Project"
      click_on 'Save'
    end

    wait_for_ajax

    within(:css, '.project') do
      expect(page).to have_content("My First Project")  
    end

    click_on 'New Project'

    within(:css, '.project') do
      fill_in 'project_title', with: "My Second Project"
      click_on 'Save'
    end

    wait_for_ajax

    within(:css, '.project') do
      expect(page).to have_content("My Second Project")   
    end
    within(:css, 'aside') do
      expect(page).to have_content("My First Project")   
      expect(page).to have_content("My Second Project")   
    end    
  end  

end
