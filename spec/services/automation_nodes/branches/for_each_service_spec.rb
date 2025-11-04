require_relative "../../../spec_helper"

describe AutomationNodes::Branches::ForEachService, logged: :admin do
  describe "#related_entities" do
    let(:metadata) { {} }
    let(:prev_data) { {} }
    let(:prev_result) { AutomationService::Result.new(true, prev_data) }
    let(:automation_node) { FactoryBot.create(:branch_for_each, metadata: metadata) }
    let(:automation_pipeline) { FactoryBot.create(:automation_pipeline, prev_result: prev_result) }
    let(:issue) { automation_pipeline.entity }

    subject { described_class.new(automation_pipeline, automation_node).send(:related_entities) }

    context "related_issues - current" do
      let(:metadata) { { "related_issues" => "current" } }

      it { is_expected.to eq [issue] }
    end

    context "related_issues - parent" do
      let(:metadata) { { "related_issues" => "parent" } }

      context "when issue has no parent" do
        it { is_expected.to eq [] }
      end

      context "when issue has parent" do
        let(:parent) { FactoryBot.create(:issue, project: issue.project) }

        before { issue.reload.update(parent: parent) }

        it { is_expected.to eq [parent] }
      end
    end
  end
end
