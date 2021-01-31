require 'rails_helper'

RSpec.feature 'Users can delete projects' do
  let(:project) { FactoryBot.create(:project) }

  # TODO: User should only be able to delete her own project.
  scenario 'successfully deleting a project' do
    visit project_path(project)

    click_link 'Delete Project'

    expect(page).to have_content 'Project has been deleted.'
    expect(current_path).to eq projects_path
    expect(page).to_not have_content project.title
    expect(page).to_not have_content project.content
  end
end
