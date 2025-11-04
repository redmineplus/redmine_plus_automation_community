require_relative '../../../spec_helper'

describe AutomationNodes::Actions::CloneIssueService, logged: :admin do
  let(:metadata) { {} }
  let(:automation_node) { FactoryBot.create(:action_clone_issue, metadata: metadata) }
  let(:automation_pipeline) { FactoryBot.create(:automation_pipeline) }
  let(:issue) { automation_pipeline.entity }
  let(:project) { issue.project }

  describe "#call" do
    let(:user) { FactoryBot.create(:user) }
    let!(:cf_text) { FactoryBot.create(:issue_custom_field, projects: [project], trackers: project.trackers, field_format: "text") }
    let!(:cf_text2) { FactoryBot.create(:issue_custom_field, projects: [project], trackers: project.trackers, field_format: "text") }
    let!(:cf_user) { FactoryBot.create(:issue_custom_field, projects: [project], trackers: project.trackers, field_format: "user") }
    let(:metadata) { {"issue"=>{"project_id"=>{"label"=>"<< same as source issue >>", "value"=>"issue.project.id"}, "subject"=>"Clone of {{issue.subject}}", "cf_#{cf_text.id}"=>"test {{issue.id}}", "cf_#{cf_user.id}"=>{"value"=>user.id.to_s, "label"=>"ivan Marangoz"}}} }
    let(:cloned_issue) { result.data[:created] }

    let(:result) { described_class.call(automation_pipeline, automation_node) }

    before do
      issue.reload.custom_field_values = { cf_text.id => "test {{issue.id}}", cf_user.id => user.id.to_s, cf_text2.id => "test2" }
      issue.save
    end

    it "assigns correct attributes to cloned issue" do
      expect(result.success?).to eq true
      expect(cloned_issue.subject).to eq("Clone of #{issue.subject}")
      expect(cloned_issue.custom_value_for(cf_text).value).to eq("test #{issue.id}")
      expect(cloned_issue.custom_value_for(cf_user).value).to eq(user.id.to_s)
      expect(cloned_issue.custom_value_for(cf_text2).value).to eq("test2")
    end
  end
end