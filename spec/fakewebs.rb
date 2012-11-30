require 'fakeweb'

pages = File.expand_path('../fakeweb_pages/', __FILE__)

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(
  :get,
  'http://www.travian.com',
  :body => File.read(pages + '/www.travian.com.html'),
  :content_type => "text/html"
)
