require "yaml"

module Database
  class Registry
    def self.build(name, url:)
      config = YAML.safe_load_file(
        File.expand_path("../../config/databases.yml", __dir__)
      )

      database = config.fetch("databases").fetch(name)

      raise "Database disabled: #{name}" unless database["enabled"]

      require_relative "adapters/#{database.fetch('adapter_file')}"

      adapter_class = database.fetch("adapter_class").split("::").inject(Object) do |namespace, constant|
        namespace.const_get(constant)
      end

      adapter_class.new(url: url)
    end
  end
end
