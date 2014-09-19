class CreateRowsService
  require 'csv'

  attr_reader :document

  def initialize document
    @document = document
  end

  def perform
    text = File.read(@document.file.path)
    rows = CSV.parse(text, :headers => false)
    rows.each do |row|
      @document.rows.create(Hash[Row::FIELDS.zip row])
    end
  end
end