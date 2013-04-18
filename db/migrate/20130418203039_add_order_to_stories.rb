class AddOrderToStories < ActiveRecord::Migration
  def change
    add_column :stories, :order, :integer
  end
end
