require 'spec_helper'

describe StaticPagesController do

  subject { page }

  #share same test sentence with similar test module.
  shared_examples_for "all_pages" do
    it { should have_selector('title', text: title_info) }
    it { should have_selector('h1', text: head_info) }
  end

  describe "'home' page" do
    before { visit root_path }

    let(:title_info) { full_title("") }
    let(:head_info) { "Welcome to the Sample App" }

    it_should_behave_like "all_pages"

    describe "micropost" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:mp) { FactoryGirl.create(:micropost, user: user) }
      before do
        sign_in user
        visit root_path
      end

      it { should have_selector('h1', text: user.name) }
      it { should have_link('view my profile', href: user_path(user)) }
      it { should have_content('1 micropost') }
      it { should have_button('Post') }

      it "should not change microposts count" do
        expect do
          click_button "Post"
        end.not_to change(Micropost, :count)
      end

      it "should have error message" do
        click_button "Post"
        page.should have_content('error')
      end

      describe "feed item" do
        let(:other) { FactoryGirl.create(:user) }
        let!(:other_mp) { FactoryGirl.create(:micropost,
                                             content: "other content", user: other) }

        it { should have_content(mp.content) }
        it { should have_link('delete') }

        describe "after click 'delete' link" do
          it "should change microposts count by -1" do
            expect do
              click_link 'delete'
            end.to change(Micropost, :count).by(-1)
          end
        end

        it { should_not have_content(other_mp.content) }

        describe "after following other user" do
          before do
            user.follow!(other)
            visit root_path
          end
          it { should have_content(other_mp.content) }
        end
      end
    end

    describe "stats" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:followed) { FactoryGirl.create(:user) }
      before do
        user.follow!(followed)
        sign_in user
        visit root_path
      end

      it { should have_link('0 followers', href: followers_user_path(user)) }
      it { should have_link('1 following', href: following_user_path(user)) }
    end
  end

  describe "'help' page" do
    before { visit help_path }

    let(:title_info) { full_title("Help") }
    let(:head_info) { "Help" }

    it_should_behave_like "all_pages"
  end

  describe "'about' page" do
    before { visit about_path }

    let(:title_info) { full_title("About") }
    let(:head_info) { "About Us" }

    it_should_behave_like "all_pages"
  end

  describe "'contact' page" do
    before { visit contact_path }

    let(:title_info) { full_title("Contact") }
    let(:head_info) { "Contact" }

    it_should_behave_like "all_pages"
  end
end
