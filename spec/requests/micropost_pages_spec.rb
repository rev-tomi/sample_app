require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      
      it "should not create micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    let (:other_user) { FactoryGirl.create(:user) }
    before { FactoryGirl.create(:micropost, user: user, content: "Foo") }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as other user" do
      before do
        sign_in other_user
        visit user_path(user)
      end
      it { should have_content("Foo") }
      it { should_not have_link("delete") }
      it { should_not have_content("delete") }
    end
  end

  describe "pagination" do
    before { 1.upto(50){ |i| FactoryGirl.create(:micropost, user: user, content: "Foo - #{i}") } }
    after { user.microposts.delete_all }
    
    before { visit user_path(user) }

    it { should have_selector('div.pagination') }
    it "should list each micropost" do
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content(micropost.content)
      end
    end
  end
end

