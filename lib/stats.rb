class Stats
  def self.matches?(request)
    request.subdomain.present? && request.subdomain == 'stats'
  end
end