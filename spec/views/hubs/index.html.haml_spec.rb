require 'spec_helper'

describe "hubs/index" do
  before(:each) do
    assign(:hubs, FactoryGirl.build_list(:hub, 5))
  end

  it "renders a list of hubs" do
    render
    assert_select "tbody>tr>td:nth-child(3)", text: %r{www\.travian\.}, count: 5
  end

  it "should have a table header" do
    render
    assert_select "thead", count: 1
  end

  it 'should have 4 header columns' do
    render
    assert_select "tr>th", count: 4
  end

  it 'should have 4 table body columns' do
    render
    assert_select "tbody>tr:first-child>td", count: 4
  end

end
