<<<<<<< HEAD
=======
# frozen_string_literal: true

>>>>>>> 03b3ae509307ddae5d3a471276db49c69409d2c6
class AddDetailsToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :contact_address, :string
    add_column :representatives, :political_party, :string
    add_column :representatives, :photo_url, :string
  end
end
