class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :weight, default: 0, null: false

      t.timestamps
    end
  end
end
