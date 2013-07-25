require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  let(:micropost) { user.microposts.build(content: "valid content") }
  subject { micropost }

  it { should respond_to(:user_id) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  describe "validation" do

    describe "when user_id is no present" do
      before { micropost.user_id = nil }
      it { should_not be_valid }
    end

    describe "when content is no present" do
      before { micropost.content = nil }
      it { should_not be_valid }
    end

    describe "when content is too long" do
      before { micropost.content = "a" * 141 }
      it { should_not be_valid }
    end
  end
end
