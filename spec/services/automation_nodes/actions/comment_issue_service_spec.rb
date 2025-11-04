require_relative "../../../spec_helper"

describe AutomationNodes::Actions::CommentIssueService, logged: :admin do
  describe "#call" do
    let(:metadata) { {} }
    let(:automation_node) { FactoryBot.create(:action_comment_issue, metadata: metadata) }
    let(:automation_pipeline) { FactoryBot.create(:automation_pipeline) }
    let(:issue) { automation_pipeline.entity }

    let(:result) { described_class.call(automation_pipeline, automation_node) }

    context "when the comment is valid" do
      let(:comment) { "This is a test comment" }
      let(:metadata) { { comment: } }

      it "creates a journal with the correct comment" do
        expect(result.success?).to eq true
        expect(issue.journals.last.notes).to eq(comment)
      end
    end

    context "when the comment is not valid" do
      let(:metadata) { { comment: nil } }

      it "does not create journal and raises error" do
        expect(result.success?).to eq false
        expect(issue.journals.count).to eq(0)
      end
    end

  end
end
