require_relative "../spec_helper"

describe Issue, type: :model do
  let(:issue) { FactoryBot.create(:issue) }

  describe "#automation_trigger_created" do
    context "when issue is created" do
      it "triggers IssueCreated" do
        expect(AutomationNodes::Triggers::IssueCreated).to receive(:trigger!)

        issue
      end
    end
  end

  describe "#automation_trigger_updated" do
    context "when issue is updated" do
      it "triggers IssueCreated" do
        expect(AutomationNodes::Triggers::IssueUpdated).to receive(:trigger!)
        expect(AutomationNodes::Triggers::ValueChanged).to receive(:trigger!)

        issue.reload.update(subject: "New subject")
      end
    end
  end

  describe "#automation_trigger_deleted" do
    context "when issue is deleted" do
      it "triggers IssueCreated" do
        expect(AutomationNodes::Triggers::IssueDeleted).to receive(:trigger!)

        issue.destroy
      end
    end
  end
end
