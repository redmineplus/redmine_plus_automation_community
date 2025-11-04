# This controller is used to ensure that the params include the format as JSON
class IssueToJsonController < IssuesController
  def _params
    ActionController::Parameters.new({ format: "json"})
  end

  def params
    @_params ||= _params
  end
end
