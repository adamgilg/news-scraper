class Story < ActiveRecord::Base
  attr_accessible :headline, :url, :summary, :order
end