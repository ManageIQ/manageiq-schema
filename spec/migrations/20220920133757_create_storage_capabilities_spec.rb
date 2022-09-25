require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe CreateStorageCapabilities do
  # let(:my_model_stub) { migration_stub(:MyModel) }

  migration_context :up do
    # Create data
    #
    # Example:
    #
    #   my_model_stub.create!(attributes)

    migrate

    # Ensure data exists
    #
    # Example:
    #
    #   expect(record).to have_attributes()
  end

  migration_context :down do
    # Create data
    #
    # Example:
    #
    #   my_model_stub.create!(attributes)

    migrate

    # Ensure data exists
    #
    # Example:
    #
    #   expect(MyModel.count).to eq(0)
  end
end
