require 'rails_helper'
require 'ffaker'

describe Api::UsersController do
  before(:each) { request.headers['Accept'] = "application #{Mime::JSON}"}
  before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id
    end

    it "should return success code 200" do
      expect(response.status).to eql 200
    end

    it "returns user details" do
      result = parsed_response
      expect(result[:username]).to eql @user.email
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "returns success code 201" do
        expect(response.status).to eql 201
      end

      it "returns details of record created" do
        result = parsed_response
        expect(result[:username]).to eql @user_attributes[:email]
      end
    end

    context "when invalid parameters passed" do
      before(:each) do
        @invalid_user = FactoryGirl.attributes_for :invalid_user
        post :create, { user: @invalid_user }
      end

      it "should return error code 422" do
        expect(response.status).to eql 422
      end

      it "should return error details" do
        result = parsed_response
        expect(result).to have_key :errors
        expect(result[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
    end

    context "with valid parameters" do
      before(:each) do
        put :update, { id: @user.id, first_name: "Solomon175" }
      end

      it "should return details of updated record" do
        result = parsed_response
        expect(result[:name]).to include "Solomon175"
      end

      it "should return success code 201" do
        expect(response.status).to eql 201
      end
    end

    context "with invalid parameters" do
      before(:each) do
        put :update, { id: @user.id, email: nil }
      end

      it "should return errors" do
        result = parsed_response
        expect(result).to have_key :errors
        expect(result[:errors][:email]).to include "can't be blank"
      end

      it "should return error code 422" do
        expect(response.status).to eql 422
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, id: @user.id
    end

    it "responds with 204" do
      expect(response.status).to eql 204
    end


  end

end
