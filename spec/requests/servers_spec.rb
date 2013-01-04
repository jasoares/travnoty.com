require 'spec_helper'

describe "Servers" do
  describe "GET /servers" do
    it "answers to GET /servers" do
      get servers_path
      response.status.should be(200)
    end

    it "answers to GET /servers/:id" do
      server = FactoryGirl.create(:server)
      get server_path(server)
      response.status.should be(200)
    end
  end
end
