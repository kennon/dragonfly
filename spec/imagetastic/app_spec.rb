require File.dirname(__FILE__) + '/../spec_helper'
require 'rack/mock'

describe Imagetastic::App do

  before(:each) do
    @app = Imagetastic::App.new
    @request = Rack::MockRequest.new(@app)
  end

  describe "dealing with params" do
    it "should return a 400 if the query string doesn't correspond to valid params" do
      Imagetastic.url_handler.should_receive(:query_to_params).with('wassup').and_raise Imagetastic::UrlHandler::BadParams
      res = @request.get("hello?wassup")
      res.status.should == 400
    end
  end

end