class AddProjectsCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :projects_count, :integer
  end
end
