## ARJ-Stack: AWS Simple Queue Service (SQS) module

A Terraform module for provisioning Simple Queue Service (SQS)

### Resources
This module features the following components to be provisioned with different combinations:

- SQS Queue [[aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue)]
- SQS Queue Policy [[aws_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy)]
- SQS Queue Redrive Policy [[aws_sqs_queue_redrive_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy)]
- SQS Queue Redrive Allow Policy [[aws_sqs_queue_redrive_allow_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-sqs) for effectively utilizing this module.

### Inputs

#### Queue Details

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | The name of the queue. | `string` |  | yes |
| <a name="fifo_queue"></a> [fifo_queue](#input\_fifo\_queue) | Flag to decide if it is a FIFO queue. | `bool` | `false` | no |

#### Queue Configuration

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="visibility_timeout_seconds"></a> [visibility_timeout_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). | `number` | `30` | no |
| <a name="delay_seconds"></a> [delay_seconds](#input\_delay\_seconds) | The Delay period (in seconds) should be between 0 and 900 (15 minutes). | `number` | `0` | no |
| <a name="receive_wait_time_seconds"></a> [receive_wait_time_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. | `number` | `0` | no |
| <a name="message_retention_seconds"></a> [message_retention_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. | `number` | `345600` | no |
| <a name="max_message_size"></a> [max_message_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. | `number` | `262144` | no |

#### FIFO Queue Specific Configuration

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="content_based_deduplication"></a> [content_based_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO queues. | `bool` | `false` | no |
| <a name="deduplication_scope"></a> [deduplication_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level. | `string` | `"queue"` | no |
| <a name="fifo_throughput_limit"></a> [fifo_throughput_limit](#input\_fifo\_throughput\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. | `string` | `"perQueue"` | no |

#### Queue Encryption

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_sse"></a> [enable_sse](#input\_enable\_sse) | Flag to decide whether enable server-side encryption (SSE) of message content. | `bool` | `true` | no |
| <a name="encryption_key_type"></a> [encryption_key_type](#input\_encryption\_key\_type) | Type of Encryption Key used for SSE. | `string` | `"SSE-SQS"` | no |
| <a name="kms_master_key_id"></a> [kms_master_key_id](#input\_kms\_master\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK. | `string` | `null` | no |
| <a name="kms_data_key_reuse_period_seconds"></a> [kms_data_key_reuse_period_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again | `number` | `300` | no |

#### Queue Access Policy

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="queue_senders"></a> [queue_senders](#input\_queue\_senders) | The list of identities who can send the message to the queue (AWS account IDs, ARN of IAM users and ARN of IAM Roles). | `list(string)` | `[]` | no |
| <a name="queue_receivers"></a> [queue_receivers](#input\_queue\_receivers) | The list of identities who can receive the message from the queue (AWS account IDs, ARN of IAM users and ARN of IAM Roles). | `list(string)` | `[]` | no |

#### Queue Redrive Policy (Dead-lettter Queue)

- Configuration for Dead-letter queue for this queue

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="enable_redrive"></a> [enable_redrive](#input\_enable\_redrive) | Flag to decide if, for this queue, configure the target dead letter queue to receive undeliverable messages. | `bool` | `false` | no |
| <a name="dead_letter_queue_arn"></a> [dead_letter_queue_arn](#input\_dead\_letter\_queue\_arn) | The ARN of the dead-letter queue. Required only if `enable_redrive` is set `true`. | `string` |  | yes |
| <a name="maximum_receives"></a> [maximum_receives](#input\_maximum\_receives) | The number of times a consumer tries receiving a message from a queue without deleting it before being moved to the dead-letter queue. | `number` | `10` | no |

#### Queue Redrive Allow Policy 

- Define which source queues can use this queue as the dead-letter queue

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="allow_redrive"></a> [allow_redrive](#input\_allow\_redrive) | Flag to decide if this queue is allowed to be used a dead-letter queue for other queues. | `bool` | `false` | no |
| <a name="redrive_permission"></a> [redrive_permission](#input\_redrive\_permission) | Permission for redrive. | `string` | `"allowAll"` | no |
| <a name="source_queues"></a> [source_queues](#input\_source\_queues) | The list of ARN for source queues which will be given access to use this queue as dead-letter queue. | `list(string)` | `[]` | no |

#### Queue Tags

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the Queue. | `map(string)` | `{}` | no |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="arn"></a> [arn](#output\_arn) | The ARN of the SQS queue | `string` |
| <a name="url"></a> [url](#output\_url) | The URL for the created Amazon SQS queue. | `string` |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-sqs/graphs/contributors).

