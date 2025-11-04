class AutomationService
  Result = Struct.new(:success?, :data) do
    def failure?
      !success?
    end
  end

  class AutomationError < StandardError
    attr_reader :result

    def initialize(result)
      @result = result

      super
    end
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  rescue AutomationError => e
    # @note returns the result instantly from any method when calling #failure
    e.result
  end

  attr_reader :pipeline, :node, :entity, :prev_result

  def initialize(pipeline, node)
    @pipeline = pipeline
    @node = node
    @entity = pipeline.entity
    @prev_result = pipeline.prev_result || Result.new(true, {})
    failure(message: "Issue was destroyed in previous action") if @prev_result.data[:destroyed]
  end

  # @todo change to automation user
  def automation_user
    pipeline.author
  end

  # Replaces tokens within a string.
  # Tokens are expected to be enclosed in double curly brackets, e.g., `{{issue.first_comment.notes}}`.
  # @param text [String] The string containing tokens.
  # @return [String] The processed string with tokens replaced.
  def replace_tokens(text)
    RedminePlusAutomation::Tokens::Processor.replace(text, issue: entity, initiator: pipeline.author)
  end

  # Resolves a single token string to its value.
  # The token string should not be enclosed in brackets, e.g., `issue.first_comment`.
  # @param token [String] The token string to resolve.
  # @return [Object, nil] The resolved value of the token.
  def resolve_token(token)
    context = {
      issue: entity,
      initiator: pipeline.author,
      today: Date.today,
      now: DateTime.now
    }
    RedminePlusAutomation::Tokens::Processor.resolve_token(token, context) || token
  end

  def node_message(key, options = {})
    options[:entity] ||= pipeline.entity_name
    node.node_l("messages.#{key}", options)
  end

  def result(success, data: {})
    Result.new(success, data)
  end

  def success(data: {}, message: :success)
    pipeline.log(node, message)
    result(true, data: data)
  end

  def failure(status: :failed, message:)
    pipeline.update(status: status) if AutomationPipeline.statuses[status]
    pipeline.log(node, message)
    raise AutomationError, result(false)
  end

  def skipped(message:)
    failure(status: nil, message: message)
  end
end
