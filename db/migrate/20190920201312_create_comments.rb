class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
    t.text :message
    t.text :comment
    t.integer :user_id
    t.integer :gram_id
    t.datetime
    
  end  
  end
end
