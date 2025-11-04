module AutomationNodes
  module Triggers
    class ManualTriggersController < ApplicationController
      before_action :authorize_global
      before_action :find_automation_node, only: :perform
      before_action :find_issue, only: [:perform, :visible_manual_triggers]

      def perform
        AutomationPipelineJob.schedule(@trigger_node, @issue, async: false)

        respond_to do |format|
          format.json { render json: { status: "success", message: l(:notice_trigger_performed), redirect_path: "" } }
        end
      end

      def visible_manual_triggers
        visible_rules = RedminePlusAutomation::AutomationTriggers::ManualTriggers
                          .new(User.current, @issue).visible_manual_rules

        response = visible_rules.map do |rule|
          {
            id: rule.id,
            name: rule.name,
            trigger_node_id: rule.automation_nodes.find { |node| node.is_a?(AutomationNodes::Triggers::Manual) }.id
          }
        end

        render json: response
      rescue ActiveRecord::RecordNotFound
        render json: { error: l(:error_issue_not_found) }, status: :not_found
      end

      private

      def find_issue
        @issue = Issue.find(params[:issue_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: l(:error_issue_not_found) }, status: :not_found
      end

      def find_automation_node
        @trigger_node = AutomationNode.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_404
      end
    end
  end
end