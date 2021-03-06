class CreateRowsWorker
  @queue = :parsecsv

  def self.perform document_id
    document = Document.find(document_id)
    CreateRowsService.new(document).perform
    UpdateStatisticWorker.enqueue(document_id)
  end

  def self.enqueue(document_id)
    Resque.enqueue(CreateRowsWorker, document_id)
  end
end