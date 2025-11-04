class AutomationMailer < ActionMailer::Base
  def action_triggered(to=[], cc=[], bcc=[], subject, message)
    @message = message
    @subject = subject

    mail(
      to: to,
      cc: cc,
      bcc: bcc,
      subject: @subject,
      from: Setting.mail_from || "no-reply@#{Setting.host_name}",
    ) do |format|
      format.text { render plain: @message }
      format.html { render html: @message.html_safe }
    end
  rescue StandardError => e
    Rails.logger.error("Failed to create action_triggered email: #{e.message}")
    raise e
  end

  def self.deliver_action_triggered(to: [], cc: [], bcc: [], subject:, message:)
    if to.any?
      action_triggered(to, cc, bcc, subject, message).deliver_now
    else
      Rails.logger.warn("No email address provided for AutomationMailer#action_triggered")
    end
  rescue StandardError => e
    Rails.logger.error("Failed to deliver action_triggered email: #{e.message}")
  end
end