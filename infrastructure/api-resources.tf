# API Gateway Resources and Methods

# URLs Resource
resource "aws_api_gateway_resource" "urls" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "urls"
}

resource "aws_api_gateway_resource" "url_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.urls.id
  path_part   = "{id}"
}

# URLs Methods
resource "aws_api_gateway_method" "get_urls" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.urls.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_url" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.urls.id
  http_method   = "POST"
  authorization = "NONE"
}

# Clients Integrations
resource "aws_api_gateway_integration" "get_urls" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.urls.id
  http_method             = aws_api_gateway_method.get_urls.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_url.invoke_arn
}

resource "aws_api_gateway_integration" "post_url" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.urls.id
  http_method             = aws_api_gateway_method.post_url.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.post_url.invoke_arn
}

# Method Responses
resource "aws_api_gateway_method_response" "get_urls_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.urls.id
  http_method = aws_api_gateway_method.get_urls.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "post_url_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.urls.id
  http_method = aws_api_gateway_method.post_url.http_method
  status_code = "200"
}