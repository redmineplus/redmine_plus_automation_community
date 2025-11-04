require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::IssueCategoryHandler do
  it_behaves_like "automation token handler", :issue_category
end
