class CreateBankAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.integer :account_number
      t.string :agency
      t.integer :user_id

      t.timestamps
    end

    add_index :bank_accounts, [:account_number, :agency], unique: true
  end
end
