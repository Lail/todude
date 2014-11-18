require 'spec_helper'

feature 'Visitor creates Task' do

  let!(:existing_project) { create :project }

  scenario 'add two tasks', js: true do
    visit root_path

    click_on 'New Task'

    within(:css, '.tasks') do
      fill_in 'task_title', with: "My First Task"
      click_on 'Save'
    end

    wait_for_ajax

    click_on 'New Task'

    within(:css, '.tasks') do
      fill_in 'task_title', with: "My Second Task"
      click_on 'Save'
    end

    wait_for_ajax

    within(:css, '.tasks') do
      expect(page).to have_content("My First Task")   
    end
    within(:css, '.tasks') do
      expect(page).to have_content("My Second Task")   
    end    
  end  

end
