# Lambda Permissions for API Gateway
# GET Url
resource "aws_lambda_permission" "get_url_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# POST Url
resource "aws_lambda_permission" "post_url_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Outputs
output "api_gateway_url" {
  description = "API Gateway URL"
  value       = aws_api_gateway_stage.stage.invoke_url
}