require 'uri'
require 'open-uri'
require 'openssl'
require 'date'
require 'net/http'
require 'net/https'

module AbaNumbers
  class Database

    class Row

      include Comparable

      attr_reader :aba_number, :short_name, :name, :state, :city

      def initialize(line)
        @aba_number      = line[0, 9]
        @short_name      = line[9, 18].strip
        @name            = line[27, 36].strip
        @state           = line[63, 2]
        @city            = line[65, 25].strip
        @funds_transfer  = line[90, 1]
        @settlement_only = line[91, 1]
        @securities      = line[92, 1]
        @last_updated    = line[93, 8].strip
      end

      def funds_transfer
        @funds_transfer == 'Y'
      end

      def settlement_only
        @settlement_only == 'S'
      end

      def securities
        @securities == 'Y'
      end

      def last_updated
        return nil if @last_updated.empty?
        Date.new @last_updated[0, 4].to_i, @last_updated[4, 2].to_i, @last_updated[6, 2].to_i
      end

      def to_s
        "#<AbaNumbers::Database::Row aba_number=#{aba_number.inspect} " +
          "short_name=#{short_name.inspect} name=#{name.inspect} " +
          "state=#{state.inspect} city=#{city.inspect} " +
          "funds_transfer=#{funds_transfer.inspect} settlement_only=#{settlement_only.inspect} " +
          "securities=#{securities.inspect} last_updated=#{last_updated}>"
      end

      alias :inspect :to_s

      def <=>(other)
        if other.respond_to? :aba_number
          aba_number <=> other.aba_number
        else
          to_s <=> other.to_s
        end
      end

    end

    attr_reader :url, :path

    FEDERAL_URL = 'https://www.fededirectory.frb.org/fpddir.txt'

    def initialize(url = nil, path = nil)
      @url  = url || FEDERAL_URL
      @path = path || File.join(AbaNumbers::DB_PATH, 'fpddir.txt')
    end

    def file?
      File.file? path
    end

    def line_count
      File.foreach(path).inject(0) { |c, _| c+1 }
    end

    def get_file_from_url
      uri   = URI url
      https = Net::HTTP.new uri.host, uri.port

      if uri.scheme == 'https'
        https.use_ssl     = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      res = https.request_get uri.request_uri
      File.open(path, 'w') { |f| f.puts res.body }
    end

    def read_local_file
      data.clear
      File.open(path).each_line do |line|
        line.strip!
        unless line.empty?
          row                  = Row.new line
          data[row.aba_number] = row
        end
      end
    end

    def data
      if @data.nil?
        @data = {}
        reload
      end
      @data
    end

    def [](aba_number)
      data[aba_number.to_s]
    end

    def needs_getting_file?
      !file? || line_count == 0
    end

    def reload
      get_file_from_url if needs_getting_file?
      read_local_file
      @loaded = true
    end

  end
end
