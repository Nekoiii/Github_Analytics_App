class GraphqlController < ApplicationController
  def execute
    result = excute_schema

    # Render the result with JSON format
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def excute_schema
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    ApiSchema.execute(query, variables:, context:, operation_name:)
  end

  # Ensure that variables are properly formatted for Graphql
  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    generate_variables(variables_param) || raise(ArgumentError, "Unexpected parameter: #{variables_param}")
  end

  def generate_variables(variables_param)
    case variables_param
    when String
      prepare_string_variables(variables_param)
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    end
  end

  def prepare_string_variables(variables_param)
    if variables_param.present?
      JSON.parse(variables_param) || {}
    else
      {}
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")
    errors = [{ message: err.message, backtrace: err.backtrace }]
    data = {}
    render json: { errors:, data: }, status: :internal_server_error
  end
end
