require 'spec_helper'

feature 'Visitor deletes Task' do

  let(:existing_project) { build :project }
  let!(:existing_task) { create :task, force_project: existing_project }

  scenario 'removes an existing task', js: true do
    visit root_path

    within(:css, '.tasks') do
      expect(page).to have_content(existing_task.name)
      page.has_no_css?('a.completed')   
      find('a').trigger('click')
      wait_for_ajax
      page.has_css?('a.completed')
    end

  end  

end
