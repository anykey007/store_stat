require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DocumentsController, :type => :controller, :focus=>true do

  # This should return the minimal set of attributes required to create a valid
  # Document. As you add validations to Document, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { store_id: '1' }
  }

  let(:invalid_attributes) {
    { store_id: '' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all documents as @documents" do
      document = Document.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:documents)).to include(document)
    end
  end

  describe "GET show" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :show, {:id => document.to_param}, valid_session
      expect(assigns(:document)).to eq(document)
    end
  end

  describe "GET new" do
    it "assigns a new document as @document" do
      get :new, {}, valid_session
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested document as @document" do
      document = Document.create! valid_attributes
      get :edit, {:id => document.to_param}, valid_session
      expect(assigns(:document)).to eq(document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Document" do
        expect {
          post :create, {:document => valid_attributes}, valid_session
        }.to change(Document, :count).by(1)
      end

      it "assigns a newly created document as @document" do
        post :create, {:document => valid_attributes}, valid_session
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it "redirects to the created document" do
        post :create, {:document => valid_attributes}, valid_session
        expect(response).to redirect_to(Document.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        post :create, {:document => invalid_attributes}, valid_session
        expect(assigns(:document)).to be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        post :create, {:document => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { store_id: '2'}
      }

      it "updates the requested document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => new_attributes}, valid_session
        expect(document.reload.store_id).to eq(2)
      end

      it "assigns the requested document as @document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it "redirects to the document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => valid_attributes}, valid_session
        expect(response).to redirect_to(document)
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => invalid_attributes}, valid_session
        expect(assigns(:document)).to eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Document.create! valid_attributes
        put :update, {:id => document.to_param, :document => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested document" do
      document = Document.create! valid_attributes
      expect {
        delete :destroy, {:id => document.to_param}, valid_session
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      document = Document.create! valid_attributes
      delete :destroy, {:id => document.to_param}, valid_session
      expect(response).to redirect_to(documents_url)
    end
  end

end
