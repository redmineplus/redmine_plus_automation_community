module AutomationNodes
  module Branches
    class ForEachService < ::AutomationService
      # @note branch always returns success
      def call
        entities = related_entities
        entities.each do |entity|
          AutomationBranchJob.schedule(pipeline, node, entity, async: false)
        end

        success(message: success_message(entities))
      end

      private

      # @todo add entity_type ? for now only issues, custom entities will be added later
      def related_entities
        case node.related_issues
        when "current"
          [entity]
        when "parent"
          entity.parent ? [entity.parent] : []
        else
          failure(status: :system, message: node_message(:failure_related))
        end
      end

      def linked_issues
        relations = entity.relations
        relations = relations.select { |r| node.link_types.include?(r.relation_type_for(entity)) } if node.link_types.present?
        relations.map { |r| r.other_issue(entity) }
      end

      def success_message(entities)
        related = node.node_l("fields.related_issues.options.#{node.related_issues}")
        return node_message(:success_blank, related: related) if entities.blank?

        node_message(:success, related: related, entity: "##{entities.map(&:id).join(', #')}")
      end
    end
  end
end
