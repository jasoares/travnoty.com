class Hub < ActiveRecord::Base
  attr_accessible :code, :host, :name

  validates :host, :name, :code, :presence => true

  validates :host, :format => { :with => %r[\Ahttp://\w+\.travian\.\w+(?:\.\w+)?/\Z] }

  validates :code, :length => { :minimum => 2 }
  validates :code, :format => { :with => /\A[a-z]{2,6}\Z/ }
end
