class Document < ActiveRecord::Base
  belongs_to :store
  has_many :rows, :dependent => :destroy

  has_attached_file :file
  validates_attachment_content_type :file, :content_type => %w(text/csv)

  after_save :create_rows_from_file

  private

  def create_rows_from_file
    CreateRowsService.new(self).perform if self.file.present?
  end
end
