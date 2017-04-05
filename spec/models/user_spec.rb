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

  it "is not valid without a first_name" do
    expect( FactoryGirl.build(:user, first_name: nil) ).to_not be_valid
  end

  it "is not valid without a last_name" do
    expect( FactoryGirl.build(:user, last_name: nil) ).to_not be_valid
  end

end
