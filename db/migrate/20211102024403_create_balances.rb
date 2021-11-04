class CreateBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :balances do |t|
      t.string :location
      t.date :date
      t.decimal :amount
      t.decimal :variation

      t.timestamps
    end
  end
end
