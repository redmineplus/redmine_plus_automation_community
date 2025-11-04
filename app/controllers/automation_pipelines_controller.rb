class AutomationPipelinesController < ApplicationController
  layout "admin"
  menu_item :automation_rules

  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :issues
  helper :context_menus

  before_action :find_optional_project
  before_action :authorize_global, if: -> { User.current.admin? }
  before_action :authorize, if: -> { !User.current.admin? }
  before_action :find_automation_rule
  before_action :set_main_menu

  accept_api_auth :show, :index

  def index
    retrieve_query(AutomationPipelineQuery, false)

    case params[:format]
    when "xml", "json"
      @offset, @limit = api_offset_and_limit
    else
      @limit = per_page_option
    end

    scope = @automation_rule.automation_pipelines
    @automation_pipelines_count = scope.count
    @automation_pipelines_pages = Paginator.new @automation_pipelines_count, @limit, params["page"]
    @offset ||= @automation_pipelines_pages.offset
    @automation_pipelines = scope.order(@query.sort_clause).limit(@limit).offset(@offset).to_a

    respond_to do |format|
      format.html { render layout: @project ? "base" : "admin" }
      format.api
    end
  end

  private

  def set_main_menu
    self.class.main_menu = !!@project
  end

  def find_automation_rule
    @automation_rule = AutomationRule.find(params[:rule_id])
    render_403 unless @automation_rule.visible?(User.current, @project)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end