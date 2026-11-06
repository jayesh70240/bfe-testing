module Database
  class BaseAdapter
    def initialize(url:)
      @url = url
    end

    def connect
      raise NotImplementedError
    end

    def database_name
      raise NotImplementedError
    end

    def tables
      raise NotImplementedError
    end

    def table_exists?(table)
      tables.include?(table)
    end

    def count(table)
      raise NotImplementedError
    end

    def read_only
      raise NotImplementedError
    end

    def disconnect
      raise NotImplementedError
    end
  end
end
