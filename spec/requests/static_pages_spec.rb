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
