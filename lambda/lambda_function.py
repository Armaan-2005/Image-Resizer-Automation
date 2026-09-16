import boto3
import os
import urllib.parse
from PIL import Image
from io import BytesIO

s3 = boto3.client("s3")

OUTPUT_BUCKET = os.environ["OUTPUT_BUCKET"]

def lambda_handler(event, context):

    print("Received event:")
    print(event)

    for record in event["Records"]:

        source_bucket = record["s3"]["bucket"]["name"]

        source_key = urllib.parse.unquote_plus(
            record["s3"]["object"]["key"]
        )

        print(f"Processing: s3://{source_bucket}/{source_key}")

        response = s3.get_object(
            Bucket=source_bucket,
            Key=source_key
        )

        image_data = response["Body"].read()

        image = Image.open(BytesIO(image_data))

        image.thumbnail((128, 128))

        output_buffer = BytesIO()

        image.save(
            output_buffer,
            format=image.format
        )

        output_buffer.seek(0)

        output_key = f"thumbnails/{os.path.basename(source_key)}"

        s3.put_object(
            Bucket=OUTPUT_BUCKET,
            Key=output_key,
            Body=output_buffer,
            ContentType=response.get(
                "ContentType",
                "application/octet-stream"
            )
        )

        print(
            f"Thumbnail created: "
            f"s3://{OUTPUT_BUCKET}/{output_key}"
        )

    return {
        "statusCode": 200,
        "body": "Image processed successfully"
    }