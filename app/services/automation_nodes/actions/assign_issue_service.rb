module AutomationNodes
  module Actions
    class AssignIssueService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid, assigned_to: "##{action_entity.assigned_to_id}"))

        success(message: node_message(:success, assigned_to: "##{action_entity.assigned_to_id}"))
      end

      private

      def action_base_entity
        init_entity_journal
        entity.safe_attributes = entity_attributes
        entity
      end

      def entity_attributes
        { assigned_to_id: entity_assigned_to.id }
      end

      def entity_assigned_to
        case assign_type
        when "user"
          assign_to_user
        when "user_group"
          assign_to_group
        when "user_role"
          assign_to_role
        when "field"
          assign_to_field
        when "parent_issue"
          assign_to_parent
        else
          failure(status: :system, message: node_message(:failure_assign_type, value: assign_type))
        end
      end

      def assign_to_user
        user = User.find_by(id: assigned_value)
        user || failure(message: node_message(:failure_user, value: "##{assigned_value}"))
      end

      def assign_to_group
        groups = Group.where(id: assigned_value)
        groups.empty? && failure(message: node_message(:failure_group, value: "##{assigned_value}"))

        members = groups.flat_map(&:users) & entity.project.users
        assign_by_method(members)
      end

      def assign_to_role
        roles = Role.where(id: assigned_value)
        roles.empty? && failure(message: node_message(:failure_role, value: "##{assigned_value}"))

        user_ids = roles.flat_map { |role| role.members.where(project: entity.project).pluck(:user_id) }
        # @todo only active users?
        members = User.where(id: user_ids)
        assign_by_method(members)
      end

      def assign_to_field
        user_id = resolve_token(assigned_value)
        user = User.find_by(id: user_id)
        user || failure(message: node_message(:failure_user, value: user_id))
      end

      def assign_to_parent
        entity.parent.present? ? entity.parent.assigned_to : failure(message: node_message(:failure_assign_parent))
      end

      def assign_by_method(members)
        members.empty? && failure(message: node_message(:failure_member))

        case assign_method
        when "round_robin"
          next_round_robin_member(members)
        when "random"
          members.sample
        when "balanced"
          # @todo visible issues and group with sql?
          members.min_by { |user| Issue.where(assigned_to: user).count }
        else
          failure(status: :system, message: node_message(:failure_assign_method, value: "##{assigned_value}"))
        end
      end

      def next_round_robin_member(members)
        current_index = members.index(entity.assigned_to) || -1
        members[(current_index + 1) % members.size]
      end

      def assign_type
        @assign_type ||= node.metadata.dig("assign_type", "value")
      end

      def assigned_value
        @assigned_value ||= node.metadata.dig("value").is_a?(Array) ?
                     node.metadata.dig("value").map { |v| v["value"] } :
                     node.metadata.dig("value", "value")
      end

      def assign_method
        @assign_method ||= node.metadata.dig("assign_method", "value")
      end
    end
  end
end
