require 'rails_helper'

describe User do
  before {@user = FactoryGirl.create :user }

  subject{ @user }

  it { should be_valid }
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :auth_token }

  describe "#posts association" do

    before do
      @user.save
      3.times { FactoryGirl.create :post, user: @user }
    end

    it "destroys the associated products on self destruct" do
      posts = @user.posts
      @user.destroy
      posts.each do |product|
        expect(Post.find(post)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  it "is not valid without a first_name" do
    expect( FactoryGirl.build(:user, first_name: nil) ).to_not be_valid
  end

  it "is not valid without a last_name" do
    expect( FactoryGirl.build(:user, last_name: nil) ).to_not be_valid
  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("myuniquetoken567")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "myuniquetoken567"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "myuniquetoken567")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

end
