class CreatePartyUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :party_users do |t|
      t.references :party, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :host_id

      t.timestamps
    end
  end
end
