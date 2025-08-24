class CreatePolls < ActiveRecord::Migration[8.0]
  def change
    create_table :polls do |t|
      t.string :question
      t.integer :status
      t.integer :poll_type
      t.references :user, null: false, foreign_key: true
      t.datetime :expires_at
      t.integer :max_choices

      t.timestamps
    end
  end
end
