require 'spec_helper'

describe UsersController do

  subject { page }

  describe "'new' page" do
    before { visit signup_path }

    it { should have_selector('h1', text: "Sign up") }
    it { should have_selector('title', text: "Sign up") }

    describe "with invalid information" do
      it "should not change users count" do
        expect do
          click_button "Create my account"
        end.not_to change(User, :count)
      end

      it "should have error message" do
        click_button "Create my account"
        page.should have_selector("div#error_explanation")
      end
    end

    describe "with valid information" do
      let(:name) { "Example User" }
      before do
        fill_in "Name", with: name
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should change users count by 1" do
        expect do
          click_button "Create my account"
        end.to change(User, :count).by(1)
      end

      it "should have success message" do
        click_button "Create my account"
        page.should have_selector('div.alert.alert-success', text: "Sign up success!")
      end

      it "should redirect to show page" do
        click_button "Create my account"
        page.should have_selector('h1', text: name)
      end
    end
  end

  describe "'show' page" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:mp1) { FactoryGirl.create(:micropost, user: user) }
    let!(:mp2) { FactoryGirl.create(:micropost, user: user) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "micropost show" do
      it { should have_selector('h3', text: "Microposts") }
      it { should have_content(mp1.content) }
      it { should have_content(mp2.content) }
      it { should have_content(user.microposts.count) }

      it { should have_link('delete') }

      describe "after click 'delete' link" do
        it "should change microposts count by -1" do
          expect do
            click_link 'delete'
          end.to change(Micropost, :count).by(-1)
        end
      end
    end
  end

  describe "'edit' page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should have_selector('h1', text: "Update your profile") }
    it { should have_selector('title', text: "Edit") }
    it { should have_link('changes', href: "http://gravatar.com/mails") }

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_selector('div.alert.alert-error') }
      it { should have_selector('h1', text: "Update your profile") }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "'index' page" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:another) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('h1', text: "All users") }
    it { should have_selector('title', text: "All users") }
    it "should have li tag for every user" do
      User.paginate(page: 1).each do |u|
        page.should have_selector('li', text: u.name)
      end
    end

    #it { should have_selector('div.pagination') }

    describe "delete link" do
      before { user.toggle!(:admin) }
      #it { should have_link('delete') }
    end
  end

  describe "'destroy' action" do
    let(:admin) { FactoryGirl.create(:admin) }
    let!(:another) { FactoryGirl.create(:user) }
    before do
      sign_in admin
      visit users_path
    end

    it "should change users count by -1" do
      expect do
        click_link 'delete'
      end.to change(User, :count).by(-1)
    end
  end
end
