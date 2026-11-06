require "active_record"

module Database
  module Adapters
    class PostgreSQL < BaseAdapter
      def connect
        ActiveRecord::Base.establish_connection(
          adapter: "postgresql",
          url: @url,
          pool: 2,
          connect_timeout: 10,
          variables: {
            statement_timeout: "15000"
          }
        )

        ActiveRecord::Base.connection
      end

      def connection
        ActiveRecord::Base.connection
      end

      def database_name
        connection.select_value("SELECT current_database()")
      end

      def tables
        connection.tables
      end

      def count(table)
        quoted_table = connection.quote_table_name(table)

        connection.select_value(
          "SELECT COUNT(*) FROM #{quoted_table}"
        ).to_i
      end

      def read_only
        connection.transaction do
          connection.execute("SET TRANSACTION READ ONLY")
          yield self
        end
      end

      def disconnect
        ActiveRecord::Base.connection_pool.disconnect!
      end
    end
  end
end
