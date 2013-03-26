class AddSecretTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret_token, :string
    add_column :users, :secret_token_sent_at, :datetime
  end
end
