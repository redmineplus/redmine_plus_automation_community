require_relative "../../spec_helper"

describe RedminePlusAutomation::Tokens::Processor do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:custom_field) { FactoryBot.create(:issue_custom_field, is_for_all: true, trackers: project.trackers) }
  let(:issue) do
    FactoryBot.create(:issue, project: project, author: user, custom_field_values: { custom_field.id => "Custom Value" })
  end
  let(:context) { { issue: issue, user: user } }

  describe ".replace" do
    it "replaces a simple token" do
      text = "Subject: {{issue.subject}}"
      result = described_class.replace(text, context)
      expect(result).to eq("Subject: #{issue.subject}")
    end

    it "replaces a chained token" do
      text = "Project: {{issue.project.name}}"
      result = described_class.replace(text, context)
      expect(result).to eq("Project: #{project.name}")
    end

    it "replaces a custom association token" do
      journal = FactoryBot.create(:journal, journalized: issue, notes: "First comment notes.")
      text = "First comment: {{issue.first_comment.notes}}"
      result = described_class.replace(text, context)
      expect(result).to eq("First comment: #{journal.notes}")
    end

    it "replaces a token with an argument" do
      today = Date.new(2024, 5, 10)
      text = "Due in 5 days: {{today.plus_days(5)}}"
      result = described_class.replace(text, { today: today })
      expect(result).to eq("Due in 5 days: 2024-05-15")
    end

    it "replaces a custom field token" do
      text = "CF: {{issue.cf_#{custom_field.id}}}"
      result = described_class.replace(text, context)
      expect(result).to eq("CF: Custom Value")
    end

    it "leaves an unknown token unchanged" do
      text = "Unknown: {{issue.non_existent_attribute}}"
      result = described_class.replace(text, context)
      expect(result).to eq("Unknown: {{issue.non_existent_attribute}}")
    end

    it "leaves a token for an unknown entity in the context unchanged" do
      text = "Comment: {{comment.body}}"
      result = described_class.replace(text, context)
      expect(result).to eq("Comment: {{comment.body}}")
    end

    it "handles text with mixed valid and invalid tokens" do
      text = "Subject: {{issue.subject}}, Invalid: {{issue.foo}}, Project: {{issue.project.name}}"
      result = described_class.replace(text, context)
      expect(result).to eq("Subject: #{issue.subject}, Invalid: {{issue.foo}}, Project: #{project.name}")
    end

    it "handles text with no tokens" do
      text = "This is a simple string."
      result = described_class.replace(text, context)
      expect(result).to eq("This is a simple string.")
    end

    it "uses default context for 'today' and 'now' to return the objects themselves" do
      today_date = Date.new(2024, 1, 1)
      now_time = Time.zone.parse("2024-01-01 14:30:00")
      allow(Date).to receive(:today).and_return(today_date)
      allow(Time).to receive(:current).and_return(now_time)

      text = "Date: {{today}}, Time: {{now}}"
      result = described_class.replace(text, {})
      expect(result).to eq("Date: #{today_date}, Time: #{now_time}")
    end

    it "handles tokens with surrounding whitespace" do
      text = "Subject: {{ issue.subject  }}"
      result = described_class.replace(text, context)
      expect(result).to eq("Subject: #{issue.subject}")
    end
  end
end