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
end
