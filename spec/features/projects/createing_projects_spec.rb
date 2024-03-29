require 'rails_helper'

RSpec.feature 'Users can create project' do
  let(:user) { FactoryBot.create(:user) }

  context 'locale: en' do
    scenario 'get redirected to login path' do
      visit new_user_project_path(:en, user)

      expect(page).to have_content 'You need to login first.'
    end

    scenario 'with valid inputs' do
      login_as(user)
      visit new_user_project_path(:en, user)

      fill_in 'project[title]', with: 'write a blog'
      fill_in 'project[content]', with: 'blog content'
      fill_in 'project[start_date]', with: Time.now + 1.days
      fill_in 'project[due_date]', with: Time.now + 2.days
      select  'Todo', from: 'project[status]'
      select  'Low', from: 'project[priority]'
      fill_in 'Labels', with: 'blogging, ROR'

      click_button 'Create Project'

      expect(page).to have_content 'Project has been created.'
      expect(page).to have_content 'write a blog'
      expect(page).to have_content 'blog content'
      expect(page).to have_content 'Start date: in 1 day'
      expect(page).to have_content 'Due date: in 2 days'
      expect(page).to have_content 'Status: Todo'
      expect(page).to have_content 'Priority: Low'
      within '.labels' do
        expect(page).to have_content 'blogging'
        expect(page).to have_content 'ROR'
      end
    end

    scenario 'with invalid inputs' do
      login_as(user)
      visit new_user_project_path(:en, user)
      click_button 'Create Project'

      expect(page).to have_content 'Project has not been created.'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
    end

    scenario 'with due date earlier that the start date' do
      login_as(user)
      visit new_user_project_path(:en, user)

      fill_in 'project[title]', with: 'write a blog'
      fill_in 'project[content]', with: 'blog content'
      fill_in 'project[start_date]', with: Time.now + 3.days
      fill_in 'project[due_date]', with: Time.now + 1.days
      fill_in 'Labels', with: 'blogging, ROR'

      click_button 'Create Project'
      expect(page).to have_content 'Project has not been created.'
      expect(page).to have_content "Due date can't be earlier than start date"
    end

    scenario "with title same as one of your existing project" do
      login_as(user)
      FactoryBot.create(:project, title: 'project1', user: user)
      visit new_user_project_path(:en, user)

      fill_in 'project[title]', with: 'project1'
      fill_in 'project[content]', with: 'blog content'
      click_button 'Create Project'

      expect(page).to have_content 'Project has not been created.'
      expect(page).to have_content 'Title has already been taken'
    end

    scenario "with title same as one of other user's existing project" do
      login_as(user)
      FactoryBot.create(:project, title: 'project1')
      visit new_user_project_path(:en, user)

      fill_in 'project[title]', with: 'project1'
      fill_in 'project[content]', with: 'blog content'
      click_button 'Create Project'

      expect(page).to have_content 'Project has been created.'
      expect(page).to have_content 'project1'
      expect(page).to have_content 'blog content'
    end
  end

  context 'locale: zh-TW' do
    scenario 'get redirected to login path' do
      visit new_user_project_path(:'zh-TW', user)

      expect(page).to have_content '您需要先登錄'
    end
    scenario 'with valid inputs' do
      login_as(user)
      visit new_user_project_path(:'zh-TW', user)
      
      fill_in 'project[title]', with: 'write a blog'
      fill_in 'project[content]', with: 'blog content'
      fill_in 'project[due_date]', with: Time.now + 2.days

      click_button '新專案'

      expect(page).to have_content '專案已創建'
      expect(page).to have_content 'write a blog'
      expect(page).to have_content 'blog content'
      expect(page).to have_content '2 天'
    end

    scenario 'with invalid inputs' do
      login_as(user)
      visit new_user_project_path(:'zh-TW', user)
      click_button '新專案'

      expect(page).to have_content '專案創建失敗'
      expect(page).to have_content '標題不能為空'
      expect(page).to have_content '內容不能為空'
    end

    scenario "with title same as one of your existing project" do
      login_as(user)
      FactoryBot.create(:project, title: 'project1', user: user)
      visit new_user_project_path(:'zh-TW', user)

      fill_in 'project[title]', with: 'project1'
      fill_in 'project[content]', with: 'blog content'
      click_button '新專案'

      expect(page).to have_content '專案創建失敗'
      expect(page).to have_content '標題已經存在'
    end

    scenario "with title same as one of other user's existing project" do
      login_as(user)
      FactoryBot.create(:project, title: 'project1')
      visit new_user_project_path(:'zh-TW', user)

      fill_in 'project[title]', with: 'project1'
      fill_in 'project[content]', with: 'blog content'
      click_button '新專案'

      expect(page).to have_content '專案已創建'
      expect(page).to have_content 'project1'
      expect(page).to have_content 'blog content'
    end
  end
end
