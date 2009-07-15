Class.new Sequel::Migration do

  def up
    create_table :signatures do
      primary_key :id
      String :text
      String :author
      String :source
    end

    create_table :labels do
      primary_key :id
      String :name, :unique => true
    end

    create_table :labels_signatures do
      primary_key :id
      foreign_key :label_id,     :labels
      foreign_key :signature_id, :signatures
    end
  end

  def down
    drop_table :signatures
    drop_table :labels
    drop_table :labels_signatures
  end

end
