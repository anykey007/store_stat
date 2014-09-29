class Document < ActiveRecord::Base
  belongs_to :store
  has_many :rows, :dependent => :destroy

  has_attached_file :file
  validates_attachment_content_type :file, :content_type => %w(text/csv)

  after_save :create_rows_from_file

  private

  def create_rows_from_file
    # only for heroku hack
    # heroku destroys uploaded files after the request is complet
    if ENV["HEROKU"] == '1'
      CreateRowsService.new(self).perform if self.file.present?
    else
      CreateRowsWorker.enqueue(self.id) if self.file.present?
    end
  end
end
