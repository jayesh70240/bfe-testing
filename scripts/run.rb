require "dotenv/load"
require_relative "../lib/bharat_filter_engine_testing"

dataset_name = ENV.fetch("DATASET", "popsql_marker")
dataset = Testing::Dataset.load(dataset_name)

url = ENV.fetch(dataset.url_env)

adapter = Database::Registry.build(
  dataset.database,
  url: url
)

begin
  adapter.connect

  Testing::SchemaValidator.new(
    adapter: adapter,
    dataset: dataset
  ).validate!

  Testing::FilterRunner.new(
    adapter: adapter,
    dataset: dataset
  ).run

  adapter.read_only do
    dataset.expected_tables.each do |table|
      puts "#{table}: #{adapter.count(table)} rows"
    end
  end
ensure
  adapter.disconnect
end
