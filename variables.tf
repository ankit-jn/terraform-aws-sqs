###########################
## SQS Queue Details
###########################
variable "name" {
    description = "The name of the queue."
    type        = string
}

variable "fifo_queue" {
    description = "(Optional) Flag to decide if it is a FIFO queue."
    type        = bool
    default     = false
}

###########################
## SQS Queue Configuration
###########################
variable "visibility_timeout_seconds" {
    description = "(Optional) The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)."
    type        = number
    default     = 30

    validation {
        condition = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200 
        error_message = "The Visibility timeout (in seconds) should be between 0 and 43200 (12 hours) [both inclusive]."
    }
}

variable "delay_seconds" {
    description = "(Optional) The time in seconds that the delivery of all messages in the queue will be delayed."
    type        = number
    default     = 0

    validation {
        condition = var.delay_seconds >= 0 && var.delay_seconds <= 900 
        error_message = "The Delay period (in seconds) should be between 0 and 900 (15 minutes) [both inclusive]."
    }
}

variable "receive_wait_time_seconds" {
    description = "(Optional) The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning."
    type        = number
    default     = 0

    validation {
        condition = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20 
        error_message = "The ReceiveMessage waiting period (in seconds) should be between 0 and 20 [both inclusive]."
    }
}

variable "message_retention_seconds" {
    description = "(Optional) The number of seconds Amazon SQS retains a message."
    type        = number
    default     = 345600 ## 4 days

    validation {
        condition = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600 
        error_message = "The Retention period (in seconds) should be between 60 (1 minute) and 1209600 (14 days) [both inclusive]."
    }
}

variable "max_message_size" {
    description = "(Optional) The limit of how many bytes a message can contain before Amazon SQS rejects it."
    type        = number
    default     = 262144

    validation {
        condition = var.max_message_size >= 0 && var.max_message_size <= 262144
        error_message = "The total bytes a message is allowed to carry, from 1024 bytes (1 KiB) upto 262144 bytes (256 KiB)."
    }
}

#########################################
## SQS FIFO Queue Specific Configuration
#########################################
variable "content_based_deduplication" {
    description = "(Optional) Enables content-based deduplication for FIFO queues."
    type        = bool
    default     = false
}

variable "deduplication_scope" {
    description = "(Optional) Specifies whether message deduplication occurs at the message group or queue level."
    type        = string
    default     = "queue"

    validation {
        condition = contains(["queue", "messageGroup"], var.deduplication_scope)
        error_message = "Valid Values for `deduplication_scope` are `queue` and `messageGroup`."
    }
}

variable "fifo_throughput_limit" {
    description = "(Optional) Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group."
    type        = string
    default     = "perQueue"

    validation {
        condition = contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
        error_message = "Valid Values for `fifo_throughput_limit` are `perQueue` and `perMessageGroupId`."
    }
}

###########################
## SQS Queue Encryption
###########################
variable "sqs_managed_sse_enabled" {
    description = "(Optional) Flag to decide whether enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
    type        = bool
    default     = true
}

variable "kms_managed_sse_enabled" {
    description = "(Optional) Flag to decide whether enable server-side encryption (SSE) of message content with KMS managed encryption keys."
    type        = bool
    default     = false
}

variable "kms_master_key_id" {
    description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK."
    type        = string
    default     = "alias/aws/sqs"
}

variable "kms_data_key_reuse_period_seconds" {
    description = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again."
    type        = number
    default     = 300 ## 5 Minutes

    validation {
        condition = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400 
        error_message = "The Reuse Period for KMS Data Key (in seconds) should be between 60 seconds (1 minute) and 86,400 seconds (24 hours) [both inclusive]."
    }
}

###########################
## SQS Queue Access policy
###########################
variable "policy_contents" {
    description = "(Optional) The json policy statement to be added in Queue Access Policy"
    type        = string
    default     = ""
}

variable "queue_senders" {
    description = "The list of identities who can send the message to the queue (AWS account IDs, ARN of IAM users and ARN of IAM Roles)."
    type        = list(string)
    default     = []
}

variable "queue_receivers" {
    description = "The list of identities who can receive the message from the queue (AWS account IDs, ARN of IAM users and ARN of IAM Roles)."
    type        = list(string)
    default     = []
}

###########################
## SQS Queue Redrive policy
###########################
variable "enable_redrive" {
    description = "(Optional) Flag to decide if, for this queue, configure the target dead letter queue to receive undeliverable messages."
    type        = bool
    default     = false
}

variable "dead_letter_queue_arn" {
    description = "(Optional) The ARN of the dead-letter queue. Required if `enable_redrive` is set `true`."
    type        = string
    default     = null
}

variable "maximum_receives" {
    description = "(Optional) The number of times a consumer tries receiving a message from a queue without deleting it before being moved to the dead-letter queue."
    type        = number
    default     = 10

    validation {
        condition = var.maximum_receives >= 1 && var.maximum_receives <= 1000 
        error_message = "The maximum receive count should be between 1 and 1000 (both inclusive)."
    }
}
############################################
## SQS Queue Redrive Allow Policy
#############################################
variable "allow_redrive" {
    description = "(Optional) Flag to decide if this queue is allowed to be used a dead-letter queue for other queues."
    type        = bool
    default     = false
}

variable "redrive_permission" {
    description = "(Optional) Permission for redrive."
    type        = string
    default     = "allowAll"

    validation {
        condition = contains(["allowAll", "byQueue", "denyAll"], var.redrive_permission)
        error_message = "Possible values for `redrive_permission` are `allowAll`, `byQueue` and `denyAll`."
    }
}

variable "source_queues" {
    description = "(Optional) The list of ARN for source queues which will be given access to use this queue as dead-letter queue."
    type        = list(string)
    default     = []

    validation {
        condition = length(var.source_queues) <= 10
        error_message = "Only 10 queues can be used as source for this queue."
    }
}

###########################
## SQS Queue Tags
###########################
variable "tags" {
    description = "(Optional) A map of tags to assign to the Queue."
    type        = map(string)
    default     = {}
}