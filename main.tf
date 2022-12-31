resource aws_sqs_queue "this" {
    
    ## Queue Details
    name = var.name
    fifo_queue = var.fifo_queue

    ## Queue Configuration
    visibility_timeout_seconds  = var.visibility_timeout_seconds
    delay_seconds               = var.delay_seconds
    receive_wait_time_seconds   = var.receive_wait_time_seconds
    message_retention_seconds   = var.message_retention_seconds
    max_message_size = var.max_message_size

    ## FIFO Queue Configuration
    content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
    deduplication_scope = var.fifo_queue ? var.deduplication_scope : null
    fifo_throughput_limit = var.fifo_queue ? var.fifo_throughput_limit : null

    ## Queue Encryption
    sqs_managed_sse_enabled = var.enable_sse
    
    kms_master_key_id = (var.enable_sse 
                            && var.encryption_key_type == "SSE-KMS") ? var.kms_master_key_id : null
    kms_data_key_reuse_period_seconds = (var.enable_sse 
                                            && var.encryption_key_type == "SSE-KMS") ? var.kms_data_key_reuse_period_seconds : null

    tags = merge({"Name" = var.name}, {"FIFO" = var.fifo_queue }, var.tags)

    lifecycle {
        ignore_changes = [
            policy,
            redrive_policy,
            redrive_allow_policy
        ]
    }
}

## Queue Access Policy
resource aws_sqs_queue_policy "this" {
    queue_url = aws_sqs_queue.this.id
    policy = data.aws_iam_policy_document.compact.json
}

## Queue Redrive Policy
resource aws_sqs_queue_redrive_policy "this" {
    count = var.enable_redrive ? 1 : 0

    queue_url = aws_sqs_queue.this.id

    redrive_policy = jsonencode({
        deadLetterTargetArn = var.dead_letter_queue_arn
        maxReceiveCount     = var.maximum_receives
    })
}

## Queue Redrive Allow Policy
resource aws_sqs_queue_redrive_allow_policy "this" {
    count = var.allow_redrive ? 1 : 0

    queue_url = aws_sqs_queue.this.id

    redrive_allow_policy = jsonencode({
        redrivePermission = var.redrive_permission,
        sourceQueueArns   = var.redrive_permission == "byQueue" ? var.source_queues : null
    })
}