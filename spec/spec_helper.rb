require 'rubygems'
gem 'rspec'
require 'net/http'
require 'open-uri'
require 'twitter'
require 'mechanize'

require 'webmock/rspec'
include WebMock


LIVE = ENV['LIVE']
WebMock.allow_net_connect! if LIVE


require File.join(File.dirname(__FILE__), '..', 'lib', 'net-http-spy')


class DummyLogger

  attr_accessor :lines
  attr_accessor :line

  def initialize
    reset!
  end

  def <<(msg)
    @lines << msg
    @line = msg
  end

  def info(msg)
     @lines << msg
     @line = msg
  end

  def debug(msg)
     @lines << msg
     @line = msg
  end

  def error(msg)
     @lines << msg
     @line = msg
  end

  def reset!
    @lines = []
    @line = nil
  end

end
