require 'net/https'
require 'logger'
require 'cgi'
require 'rails'

# HTTP SPY
module Net
  class HTTP

    alias :old_initialize :initialize
    alias :old_request :request

    class << self
      attr_accessor :http_logger
      attr_accessor :http_logger_options
    end

    def logger
      self.class.http_logger
    end

    def initialize(*args, &block)
      self.class.http_logger_options ||= {}
      defaults =  {:body => false, :trace => false, :verbose => false, :limit => -1}
      self.class.http_logger_options = (self.class.http_logger_options == :default) ? defaults : self.class.http_logger_options
      @logger_options = defaults.merge(self.class.http_logger_options)
      @params_limit = @logger_options[:params_limit] || @logger_options[:limit]
      @body_limit   = @logger_options[:body_limit]   || @logger_options[:limit]

      old_initialize(*args, &block)
      @debug_output   = self.class.http_logger if @logger_options[:verbose]
    end

    def request(*args, &block)
      result = nil
      req = args[0].class::METHOD
      payload = {
          address: self.address,
          port: self.port,
          path: args[0].path,
      }
      ActiveSupport::Notifications.instrument("#{req.downcase}.httpspy", payload) do
        result = old_request(*args, &block)
        payload[:code] = result.code
        payload[:content_length] = result.body.bytesize
      end
      result
    end
  end
end

module HttpInstrumentation
  class LogSubscriber < ActiveSupport::LogSubscriber
    def get(event)
      name = '%s (%.1fms)' % ["HTTP GET", event.duration]
      # produces: 'query: "foo" OR "bar", rows: 3, ...'
      query = event.payload.map{ |k, v| "#{k}: #{color(v, BOLD, true)}" }.join(', ')
      debug "  #{color(name, YELLOW, true)}  [ #{query} ]"
    end
  end
end

HttpInstrumentation::LogSubscriber.attach_to :httpspy