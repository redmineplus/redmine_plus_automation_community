require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::IssueHandler do
  describe "#value_for" do
    it_behaves_like "automation token handler", :issue
  end
end
