require_relative '../spec_helper'

describe RedminePlusAutomation::IssueJsonHandler do
  let(:issue) { FactoryBot.create(:issue) }
  let(:issue_json_handler) { described_class.new(issue) }

  describe "#to_json" do
    it "renders issue JSON representation" do
      json_output = issue_json_handler.to_json
      expect(json_output).to include(issue.id.to_s)
      expect(json_output).to include(issue.subject)
      expect(json_output).to include(issue.project.name)
      expect(json_output).to include(issue.tracker.name)
    end
  end
end
