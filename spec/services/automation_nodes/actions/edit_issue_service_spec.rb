require_relative '../../../spec_helper'

describe AutomationNodes::Actions::EditIssueService, logged: :admin do
  let(:automation_node) { FactoryBot.create(:action_edit_issue, metadata: metadata) }
  let(:automation_pipeline) { FactoryBot.create(:automation_pipeline) }
  let(:issue) { automation_pipeline.entity }
  let(:project) { issue.project }

  describe "#call" do
    let(:result) { described_class.call(automation_pipeline, automation_node) }

    context "when issue is valid" do
      let(:metadata) { { "issue" => { "description" => "New subject {{issue.subject}}" } } }

      it "edits description" do
        issue.reload
        expect(result.success?).to eq true
        expect(issue.description).to eq("New subject #{issue.subject}")
      end
    end
  end
end
