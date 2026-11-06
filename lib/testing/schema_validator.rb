module Testing
  class SchemaValidator
    def initialize(adapter:, dataset:)
      @adapter = adapter
      @dataset = dataset
    end

    def validate!
      @adapter.read_only do
        validate_database
        validate_tables
      end
    end

    private

    def validate_database
      return unless @dataset.expected_database

      actual = @adapter.database_name

      raise "Expected database #{@dataset.expected_database}, got #{actual}" unless
        actual == @dataset.expected_database
    end

    def validate_tables
      missing = @dataset.expected_tables.reject do |table|
        @adapter.table_exists?(table)
      end

      return if missing.empty?

      raise "Missing tables: #{missing.join(', ')}"
    end
  end
end
