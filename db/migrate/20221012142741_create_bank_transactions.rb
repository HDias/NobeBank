class CreateBankTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_transactions do |t|
      t.string :description, null: true
      t.string :kind, null: false, index: true
      t.string :nickname, null: false, index: true
      t.string :status, null: false, index: true
      t.integer :value, null: false

      t.belongs_to :bank_account, null: false, foreign_key: true, index: true
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
