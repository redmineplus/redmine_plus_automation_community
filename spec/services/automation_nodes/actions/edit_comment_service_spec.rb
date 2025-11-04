require_relative "../../../spec_helper"

describe AutomationNodes::Actions::EditCommentService, logged: :admin do
  describe "#call" do
    let(:comment) { "This is a test comment" }
    let(:metadata) { { comment_text: comment, target_comment: "issue.last_comment" } }
    let(:automation_node) { FactoryBot.create(:action_edit_comment, metadata: metadata) }
    let(:automation_pipeline) { FactoryBot.create(:automation_pipeline) }
    let(:issue) { automation_pipeline.entity }

    let(:result) { described_class.call(automation_pipeline, automation_node) }

    context "when there are comments" do
      let(:journal) { FactoryBot.create(:issue_journal, journalized: issue) }

      it "updates a journal with the correct comment" do
        journal
        expect(result.success?).to eq true
        expect(journal.reload.notes).to eq(comment)
      end
    end

    context "when there are no comments" do
      it "returns failure" do
        expect(result.success?).to eq false
      end
    end

  end
end
