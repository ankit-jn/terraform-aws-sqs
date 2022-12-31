output "arn" {
    description = "The ARN of the SQS queue"
    value       = aws_sqs_queue.this.arn
}

output "url" {
    description = "The URL for the created Amazon SQS queue."
    value       = aws_sqs_queue.this.url
}
