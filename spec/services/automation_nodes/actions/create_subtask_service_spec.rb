require_relative '../../../spec_helper'

describe AutomationNodes::Actions::CreateSubtaskService, logged: :admin do
  let(:automation_node) { FactoryBot.create(:action_create_subtask, metadata: metadata) }
  let(:automation_pipeline) { FactoryBot.create(:automation_pipeline) }
  let(:issue) { automation_pipeline.entity }
  let(:project) { issue.project }

  describe "#call" do
    let(:result) { described_class.call(automation_pipeline, automation_node) }
    let(:created_issue) { result.data[:created] }

    context "when issue is invalid" do
      let(:metadata) { {} }

      it "does not create new issue" do
        expect(result.success?).to eq false
      end
    end

    context "when issue is valid" do
      let(:metadata) { {"issue"=>{"project_id"=>{"value"=>"{{issue.project.id}}"}, "subject"=>"New issue from {{issue.subject}}"}} }

      it "creates new subtask" do
        expect(result.success?).to eq true
        expect(created_issue.subject).to eq("New issue from #{issue.subject}")
        expect(created_issue.parent_id).to eq(issue.id)
      end
    end
  end
end