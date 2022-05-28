class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :shipping_name
      t.string :billing_name

      t.timestamps
    end
  end
end
