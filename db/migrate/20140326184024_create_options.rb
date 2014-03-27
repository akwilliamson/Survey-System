class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.column :descriptionA, :string
      t.column :descriptionB, :string
      t.column :descriptionC, :string
      t.column :descriptionD, :string
      t.column :question_id, :integer
    end
  end
end
