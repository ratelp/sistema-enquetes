class PreservePollAndVoteDataOnUserDeletion < ActiveRecord::Migration[8.0]
  def change

    add_column :polls, :author_email, :string

    change_column_null :votes, :user_id, true

  end
end
