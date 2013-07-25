require 'spec_helper'

describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "create relationship with Ajax" do
    it "should change relationships count by 1" do
      expect do
        xhr :post, :create, relationship: { followed_id: followed.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: followed.id }
      response.should be_success
    end
  end

  describe "destroy relationship with Ajax" do
    before { user.follow!(followed) }
    let(:relationship) { user.relationships.find_by_followed_id(followed.id) }

    it "should change relationships count by -1" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end
