class CreateMesages < ActiveRecord::Migration
  def change
    create_table :mesages do |t|
      t.text :content
      t.references :conversation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
