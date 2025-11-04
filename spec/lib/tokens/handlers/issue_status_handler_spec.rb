require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::IssueStatusHandler do
  it_behaves_like "automation token handler", :issue_status
end
