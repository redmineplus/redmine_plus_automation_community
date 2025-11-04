module AutomationNodes
  module Actions
    class SendEmailService < ::AutomationNodes::Actions::EntityService
      def call
        send_email
        success(message: node_message(:success, to: prepare_emails(node.to).join(", "), subject: node.subject))
      rescue StandardError, ArgumentError => e
        failure(message: node_message(:failure, to: node.to.join(","), errors: e.message))
      end

      private

      def send_email
        AutomationMailer.deliver_action_triggered(
          to: prepare_emails(node.to),
          cc: prepare_emails(node.cc),
          bcc: prepare_emails(node.bcc),
          subject: replace_tokens(node.subject),
          message: replace_tokens(node.body)
        )
      end

      def prepare_emails(recipients)
        return [] unless recipients.present?

        recipients.flat_map { |recipient| resolve_recipient(recipient) }.uniq
      end

      def resolve_recipient(recipient)
        return [recipient.strip] if recipient.match?(URI::MailTo::EMAIL_REGEXP)

        case recipient
        when /^user_(\d+)$/
          resolve_user_email(Regexp.last_match(1).to_i)
        when /^group_(\d+)$/
          resolve_group_emails(Regexp.last_match(1).to_i)
        when /^issue.cf_(\d+)$/
          resolve_custom_field_email(Regexp.last_match(1).to_i)
        else
          resolve_token_email(recipient)
        end
      end

      def resolve_user_email(user_id)
        user = User.find_by(id: user_id)
        failure(message: node_message(:failure_user, value: "##{user_id}")) unless user

        [user.mail]
      end

      def resolve_group_emails(group_id)
        group = Group.find_by(id: group_id)
        failure(message: node_message(:failure_group, value: "##{group_id}")) unless group

        group.users.map(&:mail).compact
      end

      def resolve_custom_field_email(cf_id)
        cf = CustomField.find_by(id: cf_id)
        failure(message: node_message(:failure_custom_field, value: "##{cf_id}")) unless cf

        cf_value = entity.custom_value_for(cf_id)&.value
        return [] unless cf_value.present?

        if cf.field_format == "user"
          user = User.find_by(id: cf_value)
          user&.mail.present? ? [user.mail] : []
        elsif cf_value.match?(URI::MailTo::EMAIL_REGEXP)
          [cf_value.strip]
        else
          []
        end
      end

      def resolve_token_email(token)
        value = resolve_token(token)
        value.to_s.match?(URI::MailTo::EMAIL_REGEXP) ? [value.strip] : []
      end
    end
  end
end
