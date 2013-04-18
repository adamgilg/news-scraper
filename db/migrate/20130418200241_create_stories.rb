class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :headline
      t.string :url
      t.text :summary
      
      t.timestamps
    end
  end
end
