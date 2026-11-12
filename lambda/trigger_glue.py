import boto3
import os
import urllib.parse

glue = boto3.client("glue")

def lambda_handler(event, context):

    for record in event["Records"]:

        bucket_name = record["s3"]["bucket"]["name"]

        file_key = urllib.parse.unquote_plus(
            record["s3"]["object"]["key"]
        )

        input_path = f"s3://{bucket_name}/{file_key}"

        output_path = os.environ["OUTPUT_PATH"]

        response = glue.start_job_run(
            JobName=os.environ["GLUE_JOB_NAME"],
            Arguments={
                "--S3_INPUT_PATH": input_path,
                "--S3_OUTPUT_PATH": output_path
            }
        )

        print("Glue Job Started:", response["JobRunId"])

    return {
        "statusCode": 200,
        "body": "Glue job triggered successfully"
    }
