module SinaWeibo
  module Entity
    class Base
      def initialize(data)
        @data = data
      end

      # def method_missing(method_name, *attributes)
      #   if @data.has_key?(method_name.to_s)
      #     return data_value(method_name)
      #   end
      #   nil
      # end

      def method_missing(name, *args)
        string_name = name.to_s
        if string_name =~ (/=$/)
          @data[string_name.chop] = args.first
        else
          if @data.has_key?(string_name)
            return @data[string_name]
          else
            return nil
          end
        end
      end

      def to_h
        @data
      end

      protected

      def parse_datetime(method_name)
        dv = data_value(method_name)
        return DateTime.parse dv if dv && !dv.empty?
        nil
      end

      def data_value(method_name)
        return @data[method_name.to_s]
      end
    end
  end
end
