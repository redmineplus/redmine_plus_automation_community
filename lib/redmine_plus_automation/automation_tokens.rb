module RedminePlusAutomation
    class AutomationTokens

      def self.all
        issue_tokens + global_tokens
      end

      def self.issue_tokens
        RedminePlusAutomation::Tokens::Handlers::IssueHandler.tokens(community_edition: true)
      end

      def self.global_tokens
        global_tokens = []
        RedminePlusAutomation::Tokens::Registry.global_handlers.each do |global_key, handler|
          tokens = handler.tokens(global_key, associations: false)
          global_tokens.concat(tokens)
        end
        global_tokens
      end

      def self.tokens_by_column_name
        {
          "tracker_id" => [{ label: "<< same as source issue >>", value: "issue.tracker.id" }],
          "project_id" => [{ label: "<< same as source issue >>", value: "issue.project.id" }],
          "category_id" => [{ label: "<< same as source issue >>", value: "issue.category.id" }],
          "status_id" => [{ label: "<< same as source issue >>", value: "issue.status.id" }],
          "assigned_to_id" => [
            { label: "<< user who triggered the action >>", value: "initiator.id" },
            { label: "<< same as triggered issue >>", value: "issue.assigned_to.id" },
            { label: "<< triggered issue author >>", value: "issue.author.id" },
          ],
          "priority_id" => [{ label: "<< same as source issue >>", value: "issue.priority.id" }],
          "fixed_version_id" => [{ label: "<< same as source issue >>", value: "issue.fixed_version.id" }],
          "is_private" => [{ label: "<< same as source issue >>", value: "issue.is_private" }],
        }
      end
    end
end
