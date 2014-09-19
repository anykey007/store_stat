class Document < ActiveRecord::Base
  has_many :rows, :dependent => :destroy

  has_attached_file :file
  validates_attachment_content_type :file, :content_type => %w(text/csv)
end
