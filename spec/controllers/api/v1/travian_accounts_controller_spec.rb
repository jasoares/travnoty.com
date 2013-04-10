require 'spec_helper'

describe Api::V1::TravianAccountsController do

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

end
