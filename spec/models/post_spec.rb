require 'rails_helper'

describe Post do
  let(:post) { FactoryGirl.build :post }
  subject { post }

  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:user_id) }

  context "with invalid parameters" do
    before(:each) do
      @invalid_post = FactoryGirl.build :post
      @invalid_post.tap { |ip| ip.body = nil }
    end

    it "should not be valid" do
      expect(@invalid_post).to_not be_valid
    end
  end


end
