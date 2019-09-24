require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should allow users to create comments on grams" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { gram_id: gram.id, comment: { message: 'test comment' } }
      expect(response).to redirect_to root_path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq "test comment"
    end

    it "should require user to be logged in to comment" do
      gram = FactoryBot.create(:gram)
      post :create, params: { gram_id: gram.id, comment: { message: 'test comment'}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should return http not found if gram isn't present" do
      user = FactoryBot.create(:user)
      sign_in user 
      post :create, params: { gram_id: 'None', comment: { message: 'test comment'}}
      expect(response).to have_http_status(:not_found)
    end
  end
end
