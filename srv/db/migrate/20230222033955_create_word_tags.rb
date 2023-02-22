class CreateWordTags < ActiveRecord::Migration[7.0]
  def change
    create_table :word_tags do |t|
      t.references :word, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
