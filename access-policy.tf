data aws_caller_identity "this" {}

## Compact all the policies based on conditions
data aws_iam_policy_document "compact" {
    source_policy_documents = compact([
        data.aws_iam_policy_document.queue_owner.json,
        length(var.queue_senders) > 0 ? data.aws_iam_policy_document.queue_message_sender[0].json : "",
        length(var.queue_receivers) > 0 ? data.aws_iam_policy_document.queue_message_receiver[0].json : "",
        var.policy_contents
    ])
}

## Define Queue Owner Access
data aws_iam_policy_document "queue_owner" {

    statement {
        sid    = "QueueOwnerAccess"
        effect = "Allow"

        actions = [
            "SQS:*"
        ]

        resources = [
            aws_sqs_queue.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
        }
    }
}

## Define who can send messages to the queue
data aws_iam_policy_document "queue_message_sender" {

    count = length(var.queue_senders) > 0 ? 1 : 0

    statement {
        sid    = "QueueMessageSenderAccess"
        effect = "Allow"

        actions = [
            "SQS:SendMessage"
        ]

        resources = [
            aws_sqs_queue.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = var.queue_senders
        }
    }
}

## Define who can receive messages from the queue
data aws_iam_policy_document "queue_message_receiver" {

    count = length(var.queue_receivers) > 0 ? 1 : 0

    statement {
        sid    = "QueueMessageReceiverAccess"
        effect = "Allow"

        actions = [
            "SQS:ChangeMessageVisibility",
            "SQS:DeleteMessage",
            "SQS:ReceiveMessage"
        ]

        resources = [
            aws_sqs_queue.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = var.queue_receivers
        }
    }
}