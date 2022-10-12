class CreateBankAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.integer :account_number, null: false
      t.string :agency, null: false
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :bank_accounts, [:account_number, :agency], unique: true
  end
end
