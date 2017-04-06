require 'rails_helper'

describe Api::SessionsController do
  before(:each) do
    @user = FactoryGirl.create :user
  end

  context "with valid parameters" do
    before(:each) do
      login_details = { email: @user.email, password: "12345678" }
      post :create, { session: login_details }
    end

    it "returns session details" do
      @user.reload
      expect(parsed_response[:auth_token]).to eql @user.auth_token
    end

    it "returns success code 200" do
      expect(response.status).to eql 200
    end
  end

  context "with invalid parameters" do
    before(:each) do
      login_details = { email: @user.email, password: "GreatDude1" }
      post :create, { session: login_details }
    end

    it "returns error with details" do
      expect(parsed_response[:errors]).to include "Invalid email or password"
    end

    it "returns error code 422" do
      expect(response.status).to eql 422
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, { id: @user.auth_token }
    end

    it "returns success code 204" do
      expect(response.status).to eql 204
    end
  end

end
