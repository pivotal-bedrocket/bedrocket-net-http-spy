require File.join(File.dirname(__FILE__), 'spec_helper')

# Bare bones spec to make sure the core functionality is working
describe "Net:HTTP Spying on" do
  before(:all) do
    Rails.logger = DummyLogger.new()
  end

  describe "a get request with default options" do

    before(:all) do
      stub_request(:any, "https://search.twitter.com/search.json?q=httparty").to_return(:body =>   "\{\"results\"\: 1\}", :status => 200) unless LIVE
      Net::HTTP.http_logger_options = :default
      Twitter.search('httparty')
    end

    it "should give the connection" do
      Rails.logger.line.should include("search.twitter.com")
    end

    it "should give GET uri and query string" do
      Rails.logger.line.should include("/search.json?q=httparty")
    end

    it "should give the BODY response code" do
      Rails.logger.line.should include("BODY: Net::HTTPOK")
    end
  end


  describe "a get request with body option set to true" do
    before(:each) do
      stub_request(:any, "https://search.twitter.com/search.json?q=httparty").to_return(:body =>   "\{\"results\"\: 1\}", :status => 200) unless LIVE
      Net::HTTP.http_logger_options = {:body => true}
    end

    it "should give the body output" do
      Twitter.search('httparty')
      Rails.logger.lines
      Rails.logger.lines.grep(/BODY: \{\"results\":/).should_not be_empty
    end
  end


  describe "a get request with trace option set to true" do
    before(:each) do
      Net::HTTP.http_logger_options = {:trace => true}
      stub_request(:any, "https://search.twitter.com/search.json?q=httparty").to_return(:body =>   "\{\"results\"\: 1\}", :status => 200) unless LIVE
    end

    it "should give the trace output" do
      Twitter.search('httparty')
      Rails.logger.lines.grep(/TRACE: /).should_not be_empty
    end
  end

  describe "a post request with default options" do
    before(:all) do
      Net::HTTP.http_logger_options = {:verbose => false}
      stub_request(:any, "https://search.twitter.com/search").to_return(:body => "\{\"results\"\: 1\}", :status => 200) unless LIVE
      @connection = Net::HTTP.new('search.twitter.com')
      @connection.post('/search','?q=hello')
    end

    it "should give the post url" do
      Rails.logger.lines.should include("POST /search")
    end


    if LIVE # only works if real live request
      it "should give the post params" do
        Rails.logger.lines.should include("PARAMS {\"?q\"=>[\"hello\"]} ")
      end
    end

    it "should give the BODY response code" do
      Rails.logger.lines.should include("BODY: Net::HTTPOK")
    end
  end

  after(:all) do
    Rails.logger.reset!
  end
end
