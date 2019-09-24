require 'rails_helper'

RSpec.describe GramsController, type: :controller do
   describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#show action" do
    it "should show page if gram is found" do
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 if gram is not found" do
      get :show, params: { id: 'nonsense' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should require user to be logged in to edit" do
      get :edit
      expect(response).to redirect_to new_user_session_path
    end

    it "should show edit page if gram is found" do    
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 if gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'gobbledegook' }     
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do

    it "should allow users to update grams" do
      gram = FactoryBot.create(:gram, message: "Initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: 'Changed'} }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should 404 if gram not found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: 'Nope', gram: { message: 'Changed'} }
      expect(response).to have_http_status(:not_found)
    end

    it "should render edit found unprocessable_entity" do
      gram = FactoryBot.create(:gram, message: "Initial value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: ''} }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial value"
    end   
  end

  describe "grams#new action" do
    it "should require user to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path

    end
    it "should show new form" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require user to be logged in" do
      post :create, params: {gram: {message: 'Hello!'}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should create a new gram in DB" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { gram: { message: 'Hello!', picture: fixture_file_upload("/picture.png", 'image/png')}}
      expect(response).to redirect_to root_path
      gram = Gram.last

      expect(gram.message).to eq("Hello!")

      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user
      gram_count = Gram.count
      post :create, params: { gram: { message: ''} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count    
    end
  end

  describe "grams#destroy action" do
    it "should check user is logged in and can destroy a gram in the DB" do
      gram = FactoryBot.create(:gram, message: "Initial value")
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path
    end

    it "should display 404 if attempting to destroy with an invalid id" do
      gram = FactoryBot.create(:gram, message: "Initial value")
      sign_in gram.user
      delete :destroy, params: { id: 'absoluteGarbage'}
      expect(response).to have_http_status(:not_found)
    end

    it "should show unauthorized if user not logged in" do
      gram = FactoryBot.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end
    end
end
