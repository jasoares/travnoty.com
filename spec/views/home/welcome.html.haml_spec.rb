require 'spec_helper'

describe "home/welcome.html.haml" do
  it 'should say "Coming soon...' do
    render
    assert_select "h1", text: "Coming soon..."
  end
end
