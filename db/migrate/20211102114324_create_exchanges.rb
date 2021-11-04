class CreateExchanges < ActiveRecord::Migration[6.1]
  def change
    create_table :exchanges do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :api_key
      t.string :secret_key

      t.timestamps
    end
  end
end
