require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::IssuePriorityHandler do
  it_behaves_like "automation token handler", :issue_priority
end
