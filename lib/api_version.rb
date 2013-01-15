class ApiVersion
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || matches_version?(req)
  end

  def self.[](options)
    self.new(options)
  end

  private

  def matches_version?(req)
    req.headers['Accept'].include?("application/vnd.travnoty.v#{@version}")
  end
end
