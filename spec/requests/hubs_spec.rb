require 'spec_helper'

describe "Hubs" do
  describe "GET /hubs" do
    it "answers to GET /hubs" do
      get hubs_path
      response.status.should be(200)
    end

    it "answers to GET /hubs/:id" do
      hub = FactoryGirl.create(:hub)
      get hub_path(hub)
      response.status.should be(200)
    end
  end
end
