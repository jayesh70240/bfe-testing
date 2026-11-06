require "bharat_filter_engine"

module Testing
  class FilterRunner
    def initialize(adapter:, dataset:)
      @adapter = adapter
      @dataset = dataset
    end

    def run
      raise "BharatFilterEngine not loaded" unless
        defined?(BharatFilterEngine)

      raise "BharatFilterEngine.apply missing" unless
        BharatFilterEngine.respond_to?(:apply)

      puts "Gem loaded successfully"
      puts "Filter entry point available"
      puts "Dataset: #{@dataset.name}"
    end
  end
end
