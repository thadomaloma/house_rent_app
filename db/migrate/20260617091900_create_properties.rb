class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :property_type, null: false, default: 0
      t.integer :rent, null: false
      t.integer :deposit, null: false, default: 0
      t.integer :area, null: false, default: 0
      t.string :address, null: false
      t.integer :bedrooms, null: false, default: 1
      t.integer :bathrooms, null: false, default: 1
      t.string :floor
      t.date :available_from
      t.string :contact_name, null: false
      t.string :phone, null: false
      t.string :whatsapp_number
      t.integer :status, null: false, default: 0
      t.boolean :featured, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.integer :views_count, null: false, default: 0

      t.timestamps
    end

    add_index :properties, :area
    add_index :properties, :property_type
    add_index :properties, :status
    add_index :properties, :featured
    add_index :properties, :rent
  end
end
