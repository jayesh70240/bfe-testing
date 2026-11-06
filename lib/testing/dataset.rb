require "yaml"

module Testing
  class Dataset
    attr_reader :name, :database, :url_env, :expected_database, :expected_tables

    def initialize(name, config)
      @name = name
      @database = config.fetch("database")
      @url_env = config.fetch("url_env")
      @expected_database = config["expected_database"]
      @expected_tables = config.fetch("expected_tables", [])
    end

    def self.load(name)
      config = YAML.safe_load_file(
        File.expand_path("../../config/datasets.yml", __dir__)
      )

      dataset = config.fetch("datasets").fetch(name)

      raise "Dataset disabled: #{name}" unless dataset["enabled"]

      new(name, dataset)
    end
  end
end
