
data "aws_iam_policy_document" "source_stream_read_access" {
  statement {
    actions = [
      "kinesis:Get*",
      "kinesis:List*",
      "kinesis:Describe*",
      "kinesis:SubscribeToShard"
    ]
   resources = [
      "${aws_kinesis_stream.eu-source-stream.arn}"
   ]
  }
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}





# Roles

resource "aws_iam_role" "firehose_service" {
  name = "data-ingest-firehose-${var.app_name}"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}


# S3 access Policy

resource "aws_iam_role_policy" "stream-access" {
   role = aws_iam_role.firehose_service.name
   policy_arn = aws_iam_policy.s3_access.arn
 }






# Stream access policies
