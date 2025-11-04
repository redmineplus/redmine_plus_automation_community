require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::UserHandler do
  it_behaves_like "automation token handler", :user
end
