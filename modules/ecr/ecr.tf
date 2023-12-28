resource "aws_ecr_repository" "url_shortener_app_frontend_ecr_repo" {
  name = var.url_shortener_frontend_repo_name
}

resource "aws_ecr_repository" "url_shortener_app_backend_ecr_repo" {
  name = var.url_shortener_backend_repo_name
}