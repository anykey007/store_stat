class UpdateStatisticWorker
  @queue = :update_statistic

  def self.perform document_id
    document = Document.find(document_id)
    UpdateStatisticService.new(document).perform
  end

  def self.enqueue(document_id)
    Resque.enqueue(UpdateStatisticWorker, document_id)
  end
end