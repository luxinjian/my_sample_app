require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User",
                            email: "user@example.com",
                           password: "foobar",
                           password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:create_remember_token) }
  it { should respond_to(:admin) }
  it { should_not be_admin }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:followers) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:following?) }

  describe "toggle admin attribute" do
    before { @user.toggle(:admin) }
    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is not presence" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    let(:invalid_emails) { %w[ user@example userexample.com user.1@example.com ] }

    it "should be format" do
      invalid_emails.each do |m|
        @user.email = m
        @user.should_not be_valid
      end
    end
  end

  describe "when email is none-unique" do
    let(:another) { @user.dup }
    before do
      another.save
      @user.save
    end

    it { should_not be_valid }
  end

  describe "when email with case-sensitive" do
    let(:another) { @user.dup }
    before do
      another.email.upcase!
      another.save
      @user.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "when password and password_confirmation is not equal" do
    before { @user.password = "wrong" }
    it { should_not be_valid }
  end

  describe "micropost association" do
    before { @user.save }
    let!(:mp1) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
    let!(:mp2) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

    it "should have right micropost in right order" do
      @user.microposts.should == [mp2, mp1]
    end

    describe "when user was destroy" do
      let(:microposts) { @user.microposts }
      before { @user.destroy }

      it "should not be valid" do
        microposts.each do |m|
          Micropost.find(m.id).should_not be_valid
        end
      end
    end
  end

  describe "feed" do
    before { @user.save }
    let!(:mp) { FactoryGirl.create(:micropost, user: @user) }
    its(:feed) { should include(mp) }
  end

  describe "relationships" do
    before { @user.save }
    let(:followed) { FactoryGirl.create(:user) }
    let!(:relationship) { @user.follow!(followed) }

    its(:followed_users) { should include(followed) }
    specify { followed.followers.should include(@user) }

    describe "when follower is destroyed" do
      before { @user.destroy }
      specify { Relationship.find_by_id(relationship.id).should be_nil }
    end

    describe "when followed is destroyed" do
      before { followed.destroy }
      specify { Relationship.find_by_id(relationship.id).should be_nil }
    end

    describe "after unfollow user" do
      before { @user.unfollow!(followed) }
    its(:followed_users) { should_not include(followed) }
    specify { followed.followers.should_not include(@user) }
    specify { @user.following?(followed).should be_false }
    end
  end
end
