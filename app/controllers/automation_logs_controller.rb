class AutomationLogsController < ApplicationController
  layout "admin"
  menu_item :automation_rules

  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :issues
  helper :context_menus

  before_action :find_optional_project
  before_action :authorize_global
  before_action :find_automation_pipeline
  before_action :set_main_menu

  accept_api_auth :show, :index

  def index
    retrieve_query(AutomationLogQuery, false)

    case params[:format]
    when "xml", "json"
      @offset, @limit = api_offset_and_limit
    else
      @limit = per_page_option
    end

    scope = @automation_pipeline.automation_logs
    @automation_logs = scope.order(@query.sort_clause)
    @automation_logs_count = scope.count
    @automation_logs_pages = Paginator.new @automation_logs_count, @limit, params["page"]
    @offset ||= @automation_logs_pages.offset

    respond_to do |format|
      format.html { render layout: @project ? "base" : "admin" }
      format.api
    end
  end

  private

  def set_main_menu
    self.class.main_menu = !!@project
  end

  def find_automation_pipeline
    @automation_pipeline = AutomationPipeline.find(params[:pipeline_id])
    @automation_rule = @automation_pipeline.automation_rule
    render_403 unless @automation_rule.visible?(User.current, @project)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end