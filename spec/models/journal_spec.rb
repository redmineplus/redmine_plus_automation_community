require_relative "../spec_helper"

describe Journal, type: :model do
  let(:journal) { FactoryBot.create(:issue_journal) }
  let(:journal_without_notes) { FactoryBot.create(:issue_journal, notes: "") }
  let(:project_journal) { FactoryBot.create(:project_journal) }

  before { allow_any_instance_of(Project).to receive(:journalized_attribute_names).and_return([]) }

  describe "#automation_trigger_created" do
    context "when journal is not issue" do
      it "does not trigger IssueCommentCreated" do
        expect(AutomationNodes::Triggers::IssueCommentCreated).not_to receive(:trigger!)

        project_journal
      end
    end

    context "when journal with notes is created" do
      it "triggers IssueCommentCreated" do
        expect(AutomationNodes::Triggers::IssueCommentCreated).to receive(:trigger!)

        journal
      end
    end

    context "when journal without notes is created" do
      let(:notes) { "" }

      it "does not trigger IssueCommentCreated" do
        expect(AutomationNodes::Triggers::IssueCommentCreated).not_to receive(:trigger!)

        journal_without_notes
      end
    end
  end

  describe "#automation_trigger_updated" do
    context "when journal is not issue" do
      it "does not trigger IssueCommentUpdated" do
        expect(AutomationNodes::Triggers::IssueCommentUpdated).not_to receive(:trigger!)

        project_journal.update(notes: "New notes")
      end
    end

    context "when notes is updated" do
      it "triggers IssueCommentUpdated" do
        expect(AutomationNodes::Triggers::IssueCommentUpdated).to receive(:trigger!)

        journal.update(notes: "New notes")
      end
    end
  end
end
