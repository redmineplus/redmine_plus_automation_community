module AutomationNodes
  module Actions
    class ManageWatchersService < ::AutomationNodes::Actions::EntityService
      def call
        if node.remove_all_watchers
          added = "0"
          removed = entity.watchers.pluck(:user_id).map { |id| "##{id}" }.join(", ")
          entity.watchers.delete_all
        else
          added = add_watchers.map { |u| "##{u.id}" }.join(", ")
          add_watchers.each { |user| entity.add_watcher(user) }

          removed = remove_watcher_ids.map { |id| "##{id}" }.join(", ")
          entity.watchers.where(user_id: remove_watcher_ids).delete_all
        end

        success(message: node_message(:success, added: added, removed: removed))
      end

      private

      def add_watchers
        @add_watchers ||= Principal.assignable_watchers.where(id: add_watcher_ids - remove_watcher_ids).to_a
      end

      def add_watcher_ids
        @add_watcher_ids ||= node.add_watchers.map { |w| replace_tokens(w) }
      end

      def remove_watcher_ids
        @remove_watcher_ids ||= node.remove_watchers.map { |w| replace_tokens(w) }
      end
    end
  end
end
