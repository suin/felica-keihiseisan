class CardReader < ActiveRecord::Base
  validates :name, :presence => true
  validates :token, :presence => true
end
