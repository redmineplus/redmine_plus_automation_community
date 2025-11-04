require_relative "../../../spec_helper"
describe AutomationNodes::Triggers::ManualTriggersController, type: :controller, logged: :admin do
  describe "#visible_manual_triggers" do
    let(:project) { FactoryBot.create(:project) }
    let(:issue) { FactoryBot.create(:issue, project:) }
    let!(:automation_rule) do
      FactoryBot.create(:automation_rule, enabled: true, is_for_all: true)
        .tap { |rule| rule.projects << project }
    end

    context "when logged" do
      it "returns visible manual triggers" do
        get :visible_manual_triggers, params: { issue_id: issue.id }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when issue not found" do
      it "returns not found error" do
        get :visible_manual_triggers, params: { issue_id: -1 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "error" => I18n.t(:error_issue_not_found) })
      end
    end

    context "when user not logged in" do
      let(:user) { FactoryBot.create(:user) }
      before do
        allow(User).to receive(:current).and_return(user)
      end

      it "returns unauthorized error" do
        get :visible_manual_triggers, params: { issue_id: issue.id }

        expect(response).to have_http_status(403)
      end
    end
  end
end
