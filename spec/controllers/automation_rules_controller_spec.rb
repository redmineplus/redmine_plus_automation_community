require_relative "../spec_helper"

describe AutomationRulesController, type: :controller do
  let(:enabled_modules) { [:automation_rules] }
  let(:project) { FactoryBot.create(:project, enabled_module_names: enabled_modules) }
  let(:automation_rule) { FactoryBot.create(:automation_rule, is_for_all: false, projects: [project]) }

  describe "current user is admin", logged: :admin do
    describe "#index" do
      context "with global context" do
        it "returns success" do
          get :index

          expect(response).to have_http_status(:success)
        end
      end

      context "with project context" do
        it "returns success" do
          get :index, params: { project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            get :index, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#show" do
      context "with global context" do
        it "returns success" do
          get :show, params: { id: automation_rule.id }

          expect(response).to have_http_status(:success)
        end
      end

      context "with project context" do
        it "returns success" do
          get :show, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            get :show, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#new" do
      context "with global context" do
        it "returns success" do
          get :new

          expect(response).to have_http_status(:success)
        end
      end

      context "with project context" do
        it "returns success" do
          get :new, params: { project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            get :new, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#create" do
      context "with global context" do
        it "returns success" do
          expect { post :create }.to change { AutomationRule.count }.by(1)

          expect(response).to have_http_status(:redirect)
        end
      end

      context "with project context" do
        it "returns success" do
          expect { post :create, params: { project_id: project.identifier } }.to change { AutomationRule.count }.by(1)

          expect(response).to have_http_status(:redirect)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            post :create, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#edit" do
      context "with global context" do
        it "returns success" do
          get :edit, params: { id: automation_rule.id }

          expect(response).to have_http_status(:success)
        end
      end

      context "with project context" do
        it "returns success" do
          get :edit, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            get :create, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#update" do
      let(:name) { "updated name" }

      context "with global context" do
        it "returns success" do
          put :update, params: { id: automation_rule.id, automation_rule: { name: name } }

          expect(response).to have_http_status(:redirect)
          expect(automation_rule.reload.name).to eq(name)
        end
      end

      context "with project context" do
        it "returns success" do
          put :update, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }

          expect(response).to have_http_status(:redirect)
          expect(automation_rule.reload.name).to eq(name)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            put :update, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#destroy" do
      context "with global context" do
        it "returns success" do
          automation_rule

          expect { delete :destroy, params: { id: automation_rule.id } }.to change { AutomationRule.count }.by(-1)

          expect(response).to have_http_status(:redirect)
        end
      end

      context "with project context" do
        it "returns success" do
          automation_rule

          expect { delete :destroy, params: { id: automation_rule.id, project_id: project.identifier } }.to change { AutomationRule.count }.by(-1)

          expect(response).to have_http_status(:redirect)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            delete :destroy, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#update_nodes" do
      let(:name) { "updated name" }

      context "with global context" do
        it "returns success" do
          put :update_nodes, params: { id: automation_rule.id, automation_rule: { name: name } }, format: :json

          expect(response).to have_http_status(:no_content)
          expect(automation_rule.reload.name).to eq(name)
        end
      end

      context "with project context" do
        it "returns success" do
          put :update_nodes, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }, format: :json

          expect(response).to have_http_status(:no_content)
          expect(automation_rule.reload.name).to eq(name)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            put :update_nodes, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#context_menu" do
      context "with global context" do
        it "returns success" do
          get :context_menu, params: { id: automation_rule.id }

          expect(response).to have_http_status(:success)
        end
      end

      context "with project context" do
        it "returns success" do
          get :context_menu, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "when project module is not enabled" do
          let(:enabled_modules) { [] }

          it "returns forbidden" do
            get :context_menu, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe "current user is not admin", logged: true do
    let(:permissions) { [:view_automation_rules, :manage_automation_rules] }
    let(:role) { FactoryBot.create(:role, name: "aaa", permissions: permissions) }
    let(:member) { FactoryBot.create(:member, user: User.current, project: project, roles: [role]) }

    before { member }

    describe "#index" do
      context "with global context" do
        it "returns forbidden" do
          get :index

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          get :index, params: { project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            get :index, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#show" do
      context "with global context" do
        it "returns forbidden" do
          get :show, params: { id: automation_rule.id }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          get :show, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            get :show, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#new" do
      context "with global context" do
        it "returns forbidden" do
          get :new

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          get :new, params: { project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            get :new, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#create" do
      context "with global context" do
        it "returns forbidden" do
          post :create

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          expect { post :create, params: { project_id: project.identifier } }.to change { AutomationRule.count }.by(1)

          expect(response).to have_http_status(:redirect)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            post :create, params: { project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#edit" do
      context "with global context" do
        it "returns forbidden" do
          get :edit, params: { id: automation_rule.id }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          get :edit, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            get :create, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#update" do
      let(:name) { "updated name" }

      context "with global context" do
        it "returns forbidden" do
          put :update, params: { id: automation_rule.id, automation_rule: { name: name } }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          put :update, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }

          expect(response).to have_http_status(:redirect)
          expect(automation_rule.reload.name).to eq(name)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            put :update, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#destroy" do
      context "with global context" do
        it "returns forbidden" do
          delete :destroy, params: { id: automation_rule.id }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          automation_rule

          expect { delete :destroy, params: { id: automation_rule.id, project_id: project.identifier } }.to change { AutomationRule.count }.by(-1)

          expect(response).to have_http_status(:redirect)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            delete :destroy, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#update_nodes" do
      let(:name) { "updated name" }

      context "with global context" do
        it "returns forbidden" do
          put :update_nodes, params: { id: automation_rule.id, automation_rule: { name: name } }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          put :update_nodes, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }, format: :json

          expect(response).to have_http_status(:no_content)
          expect(automation_rule.reload.name).to eq(name)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            put :update_nodes, params: { id: automation_rule.id, project_id: project.identifier, automation_rule: { name: name } }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    describe "#context_menu" do
      context "with global context" do
        it "returns forbidden" do
          get :context_menu, params: { id: automation_rule.id }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "with project context" do
        it "returns success" do
          get :context_menu, params: { id: automation_rule.id, project_id: project.identifier }

          expect(response).to have_http_status(:success)
        end

        context "without permissions" do
          let(:permissions) { [] }

          it "returns forbidden" do
            get :context_menu, params: { id: automation_rule.id, project_id: project.identifier }

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end
end
