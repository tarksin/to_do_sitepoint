Sequel.migration do
  change do
    create_table :tasks do
      primary_key :id
      String :name, :unique => true, :length => 32, :null =>false
      DateTime :completed_at
    end
  end
end
