module RedminePlusAutomation
  class IssueJsonHandler

    attr_reader :issue
    def initialize(issue)
      @issue = issue
    end

    def to_json
      IssueToJsonController.renderer.render(
        template: 'issues/show',
        formats: [:api],
        layout: false,
        assigns: {
          issue: issue,
          project: issue.project,
          allowed_statuses: issue.tracker.issue_statuses,
          journals: issue.journals,
          relations: issue.relations
        }
      )
    end
  end
end
