require 'spec_helper'

describe Relationship do
  let(:followed) { FactoryGirl.create(:user) }
  let(:follower) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should respond_to(:followed_id) }
  it { should respond_to(:follower_id) }
  it { should respond_to(:followed) }
  it { should respond_to(:follower) }
  its(:followed) { should == followed }
  its(:follower) { should == follower }

  describe "attribute validation" do

    describe "when followed_id is not present" do
      before { relationship.followed_id = nil }
      it { should_not be_valid }
    end

    describe "when follower_id is not present" do
      before { relationship.follower_id = nil }
      it { should_not be_valid }
    end
  end
end
