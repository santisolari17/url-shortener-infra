output "frontend_repository_url" {
  value = aws_ecr_repository.url_shortener_app_frontend_ecr_repo.repository_url
}

output "backend_repository_url" {
  value = aws_ecr_repository.url_shortener_app_backend_ecr_repo.repository_url
}