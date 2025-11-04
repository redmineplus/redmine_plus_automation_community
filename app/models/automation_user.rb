class AutomationUser < User
  validate :validate_anonymous_uniqueness, :on => :create

  self.valid_statuses = [STATUS_ANONYMOUS]

  def validate_anonymous_uniqueness
    # There should be only one AnonymousUser in the database
    errors.add :base, 'An Automation user already exists.' if AutomationUser.unscoped.exists?
  end

  def available_custom_fields
    []
  end

  # Overrides a few properties
  def logged?; true end
  def admin; true end
  def name(*args); I18n.t(:label_user_automation) end
  def mail=(*args); nil end
  def mail; nil end
  def time_zone; nil end
  def atom_key; nil end

  def pref
    UserPreference.new(:user => self)
  end

  # Returns the user's bult-in role
  def builtin_role
    @builtin_role ||= Role.anonymous
  end

  def membership(*args)
    nil
  end

  def member_of?(*args)
    false
  end

  protected

  def instantiate_email_address
  end
end
