class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :guest_name
      t.string :guest_email
      t.text :invitation_message
      t.integer :user_id
      t.timestamps
    end
  end
end
