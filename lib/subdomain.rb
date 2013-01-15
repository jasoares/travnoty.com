class Subdomain
  def initialize(subdomain)
    @subdomain = subdomain.to_s
  end

  def matches?(req)
    req.subdomain.present? && req.subdomain == @subdomain
  end

  def self.[](subdomain)
    self.new(subdomain)
  end
end
