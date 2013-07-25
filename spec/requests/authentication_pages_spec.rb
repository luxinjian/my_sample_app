require 'spec_helper'

describe SessionsController do

  subject { page }

  describe "'signin' page" do
    before { visit signin_path }

    it { should have_selector('title', text: "Sign in") }
    it { should have_selector('h1', text: "Sign in") }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('div.alert.alert-error', text:
                                "Invalid email/password combination.") }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }
      it { should have_selector('h1', text: user.name) }

      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }

      describe "followed sign out" do
        before { click_link "Sign out" }
        it { should_not have_link('Sign out', href: signout_path) }
        it { should have_link('Sign in', href: signin_path) }
      end
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "with none-sign_in state" do

      describe "friendly forward" do
        before { visit edit_user_path(user) }

        it { should have_selector('h1', text: "Sign in") }

        describe "after sign in" do
          before { sign_in user }
          it { should have_selector('h1', text: "Update your profile") }
          it { should have_selector('title', text: "Edit") }
        end
      end

      describe "in User's controller" do

        describe "when visit edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: "Sign in") }
        end

        describe "when get to user's edit action" do
          before { get edit_user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when put to user's update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when visit index page" do
          before { visit users_path }
          it { should have_selector('h1', text: "Sign in") }
        end

        describe "when delete to destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in Relationship's controller" do

        describe "when visit user's show page" do
          it { should_not have_button('Follow') }
          it { should_not have_button('Unfollow') }
        end

        describe "when post to relationship's create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when delete to relationship's destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "with sign_in state" do

      describe "in User's controller" do

        describe "with wrong user" do
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
          before { sign_in user }

          describe "when get to user's edit action" do
            before { get edit_user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
          end

          describe "when put to user's update action" do
            before { put user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
          end
        end

        describe "with none-admin user" do
          let(:no_admin) { FactoryGirl.create(:user) }
          before do
            sign_in no_admin
            delete user_path(user)
          end

          specify { response.should redirect_to(root_path) }
        end

        describe "with admin user" do
          let(:admin) { FactoryGirl.create(:admin) }
          before do
            sign_in admin
            user.toggle!(:admin)
            delete user_path(user)
          end

          specify { response.should redirect_to(root_path) }
        end
      end

      describe "in Micropost's controller" do

        describe "when post to micropost's create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when delete to micropost's destroy action" do
          let(:micropost) { FactoryGirl.create(:micropost) }
          before { delete micropost_path(micropost) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
  end
end
