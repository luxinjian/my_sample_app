require 'spec_helper'

describe ApplicationHelper do

  describe "full_title method" do

    it "should add page title to the full title" do
      full_title("Home").should =~ /Ruby on Rails Tutorial Sample App \| Home/
    end

    it "should just have base title" do
      full_title("").should =~ /Ruby on Rails Tutorial Sample App/
    end
  end
end

