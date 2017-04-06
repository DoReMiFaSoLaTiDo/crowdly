require 'rails_helper'

describe Api::PostsController do
  describe "GET #show" do
    before(:each) do
      @post = FactoryGirl.create :post
      get :show, id: @post.id
    end

    it "returns the details of post" do
      result = parsed_response
      expect(result[:title]).to eql @post.title
    end

    it "returns success code 200 " do
      expect(response.status).to eql 200
    end
  end

  describe "GET #index" do
    before(:each) do
      user = FactoryGirl.create :user
      api_authorization_header user.auth_token
      4.times { FactoryGirl.create :post, user: user }
      get :index, user_id: user.id
    end

    it "returns 4 records from the database" do
      result = parsed_response
      expect(result.size).to eql(4)
    end

    it "returns success code 200 " do
      expect(response.status).to eql 200
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @post_attributes = FactoryGirl.attributes_for :post
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @post_attributes }
      end

      it "renders the json representation for the product record just created" do
        result = parsed_response
        expect(result[:title]).to eql @post_attributes[:title]
      end

      it "returns success code 201 " do
        expect(response.status).to eql 201
      end
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_post_attributes = FactoryGirl.build :post, body: nil
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @invalid_post_attributes }
      end

      it "renders an errors json" do
        result = parsed_response
        expect(result).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        result = parsed_response
        expect(result[:errors][:body]).to include "can't be blank"
      end

      it "returns error code 422 " do
        expect(response.status).to eql 422
      end
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @post.id,
              post: { title: "An expensive TV" } }
      end

      it "renders the json representation for the updated user" do
        result = parsed_response
        expect(result[:title]).to eql "An expensive TV"
      end

      it "returns success code 200" do
        expect(response.status).to eql 200
      end
    end

    context "with invalid attributes" do
      before(:each) do
        # @invalid_post_attributes = @post
        # @invalid_post_attributes.tap{ |ia| ia.body = nil }
        patch :update, { user_id: @user.id, id: @post.id,
              post: { body: nil } }
      end

      it "renders an errors json" do
        result = parsed_response
        expect(result).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        result = parsed_response
        expect(result[:errors][:body]).to include "can't be blank"
      end

      it "returns error code 422" do
        expect(response.status).to eql 422
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @post.id }
    end

    it "returns success code 204" do
      expect(response.status).to eql 204
    end
  end
end
