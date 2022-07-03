output "s3_artifact_distribution_domain_name" {
  value = module.artifact_bucket.s3_bucket_bucket_regional_domain_name
  description = "The s3 bucket's domain of the for artifact distribution."
}