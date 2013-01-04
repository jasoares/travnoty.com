require 'spec_helper'

describe "hubs/show" do
  before(:each) do
    @hub = assign(:hub, stub_model(Hub,
      :host => "http://www.travian.com/"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match %r{http://www.travian.com/}
  end
end
