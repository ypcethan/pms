require 'rails_helper'

RSpec.describe 'Project index page' do
  let(:user) { FactoryBot.create(:user) }
  scenario 'need to login in order to view that page' do
    visit user_projects_path(:en, user)

    expect(page).to have_content 'You need to login first.'
  end

  scenario 'As a user, I can only view my own projects' do
    other_projects = []
    10.times do
      FactoryBot.create(:project, user: user)
      other_projects << FactoryBot.create(:project)
    end
    login_as(user)

    visit user_projects_path(:en, user)

    displayed_project_titles = page.find_all('.project-title').map(&:text)
    expected_project_titles = user.projects.all.map(&:title)
    other_project_titles = other_projects.map(&:title)

    expect(displayed_project_titles).to match_array(expected_project_titles)
    other_project_titles.each do |title|
      expect(displayed_project_titles.include?(title)).to eq(false)
    end
  end
end
