from fastapi import FastAPI, File, UploadFile
from minio import Minio
from minio.error import S3Error
import subprocess

app = FastAPI()

try:
    client = Minio(
        endpoint="play.min.io",
        port=9000,
        secure=True,
        access_key="Q3AM3UQ867SPQQA43P2F",
        secret_key="zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
    )

    found = client.bucket_exists("typadmic")
    if not found:
        client.make_bucket("typadmic")
    else:
        print("Bucket 'typadmic' already exists")
except S3Error as exc:
    print("error occurred.", exc)


# https://fastapi.tiangolo.com/tutorial/request-files/


@app.post("/files/")
async def create_file(file: bytes = File(...)):
    client.presigned_put_object(bucket_name="typademic")
    return {"file_size": len(file)}


@app.post("/uploadfile/")
async def create_upload_file(file: UploadFile):
    client.presigned_put_object(bucket_name="typademic")
    return {"filename": file.filename}


@app.get("/process")
def process():
    process = subprocess.Popen(
        ["echo", "More output"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    stdout, stderr = process.communicate()
    stdout, stderr
    # with open('test.txt', 'w') as f:
    #     process = subprocess.Popen(['ls', '-l'], stdout=f)


# def main():
# if __name__ == "__main__":
