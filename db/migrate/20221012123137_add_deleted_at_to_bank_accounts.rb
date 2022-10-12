class AddDeletedAtToBankAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bank_accounts, :deleted_at, :datetime
    add_index :bank_accounts, :deleted_at
  end
end
