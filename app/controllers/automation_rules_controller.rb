class AutomationRulesController < ApplicationController
  layout "admin"

  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper
  helper :issues
  helper :context_menus

  before_action :find_optional_project
  before_action :authorize_global, if: -> { User.current.admin? }
  before_action :authorize, if: -> { !User.current.admin? }
  before_action :find_automation_rule, only: [:edit, :update, :show, :destroy, :update_nodes]
  before_action :find_automation_rules, only: [:context_menu]
  before_action :set_main_menu

  accept_api_auth :show, :index

  def index
    retrieve_query(AutomationRuleQuery, false)

    case params[:format]
    when "xml", "json"
      @offset, @limit = api_offset_and_limit
    else
      @limit = per_page_option
    end

    @automation_rules = @query.results_scope(like: params[:name_like])
    @automation_rules_count = @automation_rules.count
    @automation_rules_pages = Paginator.new @automation_rules_count, @limit, params["page"]
    @offset ||= @automation_rules_pages.offset

    respond_to do |format|
      format.html { render layout: @project ? "base" : "admin" }
      format.api
    end
  end

  def show
    respond_to do |format|
      format.html { render layout: @project ? "base" : "admin" }
      format.api
    end
  end

  def new
    @automation_rule = AutomationRule.new

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @automation_rule = AutomationRule.new(author: User.current)
    @automation_rule.safe_attributes = params[:automation_rule]

    if @automation_rule.save
      respond_to do |format|
        format.html { redirect_back_or_default automation_rule_path(@automation_rule, project_id: @project&.identifier) }
        format.js
        format.api  { render action: "show", status: :created, location: automation_rule_url(@automation_rule) }
      end
    else
      respond_to do |format|
        format.js { render action: "new" }
        format.html { render action: "new" }
        format.api  { render_validation_errors(@automation_rule) }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @automation_rule.safe_attributes = params[:automation_rule]

    if @automation_rule.save
      respond_to do |format|
        format.html { redirect_back_or_default automation_rules_path(project_id: @project&.identifier) }
        format.js
        format.api  { render action: "show", status: :updated, location: automation_rule_url(@automation_rule) }
      end
    else
      respond_to do |format|
        format.js { render action: "edit" }
        format.html { render action: "edit" }
        format.api  { render_validation_errors(@automation_rule) }
      end
    end
  end

  def update_nodes
    @automation_rule.safe_attributes = params[:automation_rule]
    if params[:nodes]
      RedminePlusAutomation::AutomationNodes::Upsert.new(node_params, @automation_rule).call
    end
    @automation_rule.save
    respond_to do |format|
      format.api  { render_api_ok }
    end
  end

  def destroy
    @automation_rule.destroy
    flash[:notice] = l(:notice_successful_delete)

    respond_to do |format|
      format.html { redirect_back_or_default automation_rules_path(project_id: params[:project_id]) }
      format.js
      format.api { render_api_ok }
    end
  end

  def context_menu
    if @automation_rules.size == 1
      @automation_rule = @automation_rules.first
    end
    @automation_rules_ids = @automation_rules.map(&:id).sort

    can_edit = @automation_rules.detect { |c| !c.editable? }.nil?
    can_delete = @automation_rules.detect { |c| !c.deletable? }.nil?
    @can = { edit: can_edit, delete: can_delete }
    @back = back_url

    @safe_attributes = @automation_rules.map(&:safe_attribute_names).reduce(:&)

    render layout: false
  end

  private

  def node_params
    params[:nodes].map do |node|
      node.permit(
        :uuid,
        :name,
        :type,
        :nodeType,
        :value,
        :parentUuid,
        children: [],
        formProps: {}
      )
    end
  end

  def set_main_menu
    self.class.main_menu = !!@project
  end

  def find_automation_rule
    @automation_rule = AutomationRule.find(params[:id])
    # render_403 unless @automation_rule.visible?(User.current, @project)
    render_403 unless @automation_rule.editable?
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_automation_rules
    @automation_rules = AutomationRule.where(id: (params[:id] || params[:ids]))
    render_403 if @automation_rules.any? { |r| !r.editable? }
  end
end
