class AutomationNodesController < ApplicationController
  before_action :find_optional_project
  before_action :authorize_global, if: -> { User.current.admin? }
  before_action :authorize, if: -> { !User.current.admin? }
  before_action :find_automation_rule, only: [:index]

  accept_api_auth :index
  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :issues
  helper :context_menus

  def index
    @automation_nodes = @automation_rule.automation_nodes.sorted.map do |node|
      {
        id: node.id,
        uuid: node.uuid,
        name: node.name,
        description: node.description,
        position: node.position,
        type: node.mapping_type,
        nodeType: node.node_type,
        parentNodeUuid: node.parent_node_uuid,
        metadata: node.metadata
      }
    end

    respond_to do |format|
      format.json { render json: @automation_nodes }
      format.html { render plain: "Not supported", status: :not_acceptable } # Optional: handle unexpected formats
    end
  end

  private

  def find_automation_rule
    @automation_rule = AutomationRule.find(params[:automation_rule_id])
    render_403 unless @automation_rule.visible?(User.current, @project)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
