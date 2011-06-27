require 'spec_helper'

describe "profiles/new.html.haml" do
  before(:each) do
    assign(:profile, stub_model(Profile,
      :string => "",
      :string => "",
      :text => ""
    ).as_new_record)
  end

  it "renders new profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path, :method => "post" do
      assert_select "input#profile_string", :name => "profile[string]"
      assert_select "input#profile_string", :name => "profile[string]"
      assert_select "input#profile_text", :name => "profile[text]"
    end
  end
end
