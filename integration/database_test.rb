require "minitest/autorun"
require "dotenv/load"
require_relative "../lib/bharat_filter_engine_testing"

class DatabaseTest < Minitest::Test
  def setup
    @dataset = Testing::Dataset.load(
      ENV.fetch("DATASET", "popsql_marker")
    )

    @adapter = Database::Registry.build(
      @dataset.database,
      url: ENV.fetch(@dataset.url_env)
    )

    @adapter.connect
  end

  def teardown
    @adapter.disconnect if @adapter
  end

  def test_database_connection
    assert @adapter.database_name
  end

  def test_expected_tables_exist
    @dataset.expected_tables.each do |table|
      assert @adapter.table_exists?(table), "Missing table: #{table}"
    end
  end

  def test_read_only_queries
    @adapter.read_only do
      assert_operator @adapter.tables.length, :>, 0
    end
  end
end
