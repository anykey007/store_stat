class Store < ActiveRecord::Base
  has_many :documents, :dependent => :destroy
  has_many :rows, through: :documents
  has_many :statistics

  validates :name, :presence => true
end
