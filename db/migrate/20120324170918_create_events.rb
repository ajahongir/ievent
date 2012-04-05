class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.datetime :from
      t.datetime :to
      t.boolean :allDay
      t.string :repeat 
      t.timestamps
    end
  end
end
