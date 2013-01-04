module ApplicationHelper
  def strip_host(host)
    host.gsub(/\Ahttp:\/\//, '').gsub(/\/\Z/, '')
  end
end
