require 'spec_helper'

describe "servers/index" do
  before(:each) do
    hub = FactoryGirl.create(:hub)
    servers = FactoryGirl.build_list(:server, 5).each {|s| s.hubs = [hub]; s.save }
    assign(:servers, servers)
  end

  it "renders a list of servers" do
    render
    assert_select "tr>td:nth-child(5)", text: 180.days.ago.to_date.to_s , count: 5
  end

  it "should have a table header" do
    render
    assert_select "tbody", count: 1
  end

  it 'should have 9 header columns' do
    render
    assert_select "tr>th", count: 9
  end

  it 'should have 9 table body columns' do
    render
    assert_select "tbody>tr:first-child>td", count: 9
  end

  it 'should have 9 footer columns' do
    render
    assert_select "tfoot>tr>td", count: 9
  end
end
