require 'committee'
require 'rack/test'
require 'sinatra'

describe Committee::Middleware::Stub do
  include Committee::Test::Methods
  include Rack::Test::Methods

  def app
    Sinatra.new do
      get "/" do
        content_type :json
        status 200
        JSON.generate({ "foo" => "bar" })
      end

      put "/" do
        content_type :json
        status 204
      end
    end
  end

  def committee_options
    @committee_options ||= { schema: Committee::Drivers::load_from_file('docs/schema.yaml') }
  end

  def request_object
    last_request
  end

  def response_data
    [last_response.status, last_response.headers, last_response.body]
  end

  describe "GET /" do
    it "conforms to response schema with 200 response code" do
      get "/"
      assert_response_schema_confirm(200)
    end
  end

  describe "PUT /" do
    it "conforms to response schema with 204 response code" do
      put "/"
      assert_response_schema_confirm(204)
    end
  end
end