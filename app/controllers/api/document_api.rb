module API
  class DocumentApi < Grape::API
    # Set all output formats to json
    # NOTE: always functions should return hash!!!
    format :json

    resource :document do
      post '/' do
        document = Document.new
        document.file = params[:document][:file]
        document.save
      end
    end
  end
end
