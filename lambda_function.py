'''
Generic base lambda function file with S3 config loader function based
on lambda aliases

Author: Jason Witting
Version: 0.1

Copyright (c) 2016 Jason Witting

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED
, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''
import gzip
import json

import boto3

# Global vars

# name of lambda config s3 bucket'
CONFIG_BUCKET = 'lambda-function-config'
# config s3 location and filename
CONFIG_FILE = 'config.json'


def load_config(context):
    '''Load config file from S3'''
    config = ''

    # Check version
    function_name = context.function_name
    alias = context.invoked_function_arn.split(':').pop()

    if function_name == alias:
        alias = '$LATEST'
        print "No Version Set - Default to $LATEST"

    s3_client = boto3.client('s3')

    # set the file path
    file_path = '/tmp/config.json'

    # download the gzip log from s3
    s3_client.download_file(CONFIG_BUCKET, alias + "/" + CONFIG_FILE, file_path)

    with open(file_path) as f:
        config = json.load(f)

    print "Succesfully loaded config file"
    return config


def lambda_handler(event, context):
    '''Invoke Lambda '''
    # load config from json file in s3 bucket
    config = load_config(context)
    print "I'm a lambda function'"