class Row < ActiveRecord::Base
  FIELDS = [:visit_data, :mac_address, :a, :b, :c, :d, :e, :f, :g, :h]

  belongs_to :document
end
