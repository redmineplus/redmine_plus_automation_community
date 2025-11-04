require_relative '../../../spec_helper'

describe RedminePlusAutomation::Tokens::Handlers::ProjectHandler do
  it_behaves_like "automation token handler", :project
end
