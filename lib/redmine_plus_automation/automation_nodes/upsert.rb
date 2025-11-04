module RedminePlusAutomation
  module AutomationNodes
    class Upsert
      attr_reader :automation_rule
      def initialize(nodes, automation_rule)
        @nodes = nodes
        @automation_rule = automation_rule
      end

      def call
        AutomationNode.transaction do
          @nodes.each_with_index do |node, index|
            NodeBuilder.new(node, index, automation_rule).upsert
          end
          remove_nodes
        end
      end

      private

      def remove_nodes
        AutomationNode
          .where(automation_rule: automation_rule)
          .where.not(uuid: @nodes.map { |node| node['uuid'] })
          .destroy_all
      end
    end

    class NodeBuilder
      attr_reader :node_params, :index, :automation_rule

      def initialize(node_params, index, automation_rule)
        @node_params = node_params
        @index = index
        @automation_rule = automation_rule
      end

      def upsert
        if node_class.exists?(uuid: node_params['uuid'])
          node_class.find_by(uuid: node_params['uuid']).update(attributes)
        else
          node_class.create(attributes)
        end
      end

      private

      def attributes
        {
          uuid: node_params['uuid'],
          name: node_params['name'],
          description: node_params['value'],
          position: index,
          metadata: node_params['formProps'],
          automation_rule: automation_rule,
          parent_node_uuid: node_params['parentUuid']
        }
      end

      def node_class
        # 💩
        "AutomationNodes::#{node_params['nodeType'].camelize.pluralize}::#{node_params['type'].downcase.split('_').map(&:capitalize).join}".constantize
      end

    end
  end
end
