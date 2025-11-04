require_relative "../spec_helper"

describe JournalsController, type: :controller, logged: :admin do
  let(:journal) { FactoryBot.create(:issue_journal) }
  let(:journal_without_notes) { FactoryBot.create(:issue_journal, notes: "") }
  let(:project_journal) { FactoryBot.create(:project_journal) }

  before { allow_any_instance_of(Project).to receive(:journalized_attribute_names).and_return([]) }

  describe "#automation_trigger_updated_deleted" do
    context "when journal is not for an issue" do
      it "does not trigger IssueCommentDeleted" do
        expect(AutomationNodes::Triggers::IssueCommentDeleted).not_to receive(:trigger!)

        put :update, params: { id: project_journal.id, journal: { notes: "" } }
      end
    end

    context "when issue journal is updated but not deleted" do
      it "does not trigger IssueCommentDeleted" do
        expect(AutomationNodes::Triggers::IssueCommentDeleted).not_to receive(:trigger!)

        put :update, params: { id: journal.id, journal: { notes: "new notes" } }
      end
    end

    context "when issue journal is deleted after update (notes become blank)" do
      let(:journal_with_notes_only) { FactoryBot.create(:issue_journal, notes: "some notes", details: []) }

      it "triggers IssueCommentDeleted" do
        journal_with_notes_only.details.delete_all
        expect(AutomationNodes::Triggers::IssueCommentDeleted).to receive(:trigger!)

        put :update, params: { id: journal_with_notes_only.id, journal: { notes: "" } }
      end
    end
  end
end
