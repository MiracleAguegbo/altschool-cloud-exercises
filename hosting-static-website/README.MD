# Hosting a Static Website with CloudFront and AWS S3

## Overview

Create a static website on Amazon S3 bucket(private bucket) but with public read policy assigned, using cloud front for Content Delivery Network.

## Introduction

Hosting a website on the cloud is a top choice, and Amazon Web Services (AWS) provides fantastic options, especially for static sites, with services like S3 buckets and CloudFront. 

S3 buckets act as digital containers in the cloud, perfect for storing various website essentials like HTML, CSS, JavaScript, and images. They're reliable, scalable, and easy to set up for website hosting.

For the sake of this project, I'll create an IAM user with precise permissions tailored for hosting a static website on S3 and CloudFront, adhering to the principle of least privilege. With this user in place, I'll configure an S3 bucket to host the website files and enable static website hosting. Then, I'll set up a CloudFront distribution to boost website performance by caching content at edge locations worldwide. This setup acts as a content delivery network, reducing latency and ensuring a smooth user experience.

## Prerequisite

1. An AWS account
2. The files to upload for your static website.

# Steps

Step 1: Create a Bucket on Amazon S3

i. Click on create bucket to enter your desired bucket name.

![](images/1create-bucket.png)

ii. Enter a unique name for the Bucket name field, ensuring it hasn't been used before. Then, proceed to uncheck the "Block all public access" option.

![](images/2nameinput.png)

iii. Scroll down and check the acknowledgment box.

![](images/3scrolldown.png)

iv. Keep all other settings as default, then scroll down and click on "Create Bucket."

![](images/4keepevery.png)

## Step 2: Upload Website files to S3 Bucket

i. Click on the bucket name and upload the files and folders of the website.

![](images/5click-on-the-buck.png)

ii. Click on "Upload" and choose the files from your local file storage. Be careful not to upload the top-level folder containing other folders. Upload each folder separately to ensure they open correctly in your browser.

![](images/6upload-1.png)

iii. Once you've selected the folders and files from your local file storage, click on "Upload" to proceed.

![](images/6upload-2.png)

iv. Allow some time for the files to upload succesfully. Eventually, you'll see a small green bar indicating a successful upload. The click "close".

![](images/6uploadsuc22.png)

## Step 3:Enable Static Website Hosting on S3 Bucket Created

i. Navigate to the Properties tab and scroll down to find the Static website hosting section, after that click on the edit.

![](images/7propertysec1.png)

![](images/7propertysec2.png)

ii. Select the "Enable" radio button. Then, under the hosting type, choose "Host a static website." In the Index document field, enter "index.html."

![](images/8statichosting1.png)

Keep all other settings as default, then scroll down and click "Save Changes."

## Step 4 - Create And Set-up CloudFront Distribution

i. search for cloud front in the search bar and click on it, when it opens click on "Create a CloudFront distribution"

![](images/10cloudfront1.png)
![](images/10cloudfront2.png)


ii. In the "Origin domain" field, input the URL you used to access your website, which is found in your created S3 bucket under Properties >> Static website hosting. Avoid clicking on "Use website endpoint" as it won't display the Origin access control settings necessary to make your bucket private.

![](images/10cloudfront3.png)

iii. Since there is no existing Original Access Control (OAC), we'll need to create one. Click on "Create new OAC."

![](images/10cloudfront4.png)

iv. After clicking on create OAC you should see a page like this, keep all settings as default. Then click "create".

![](images/10cloudfront5.png)

v. For Web Application Firewall (WAF), select the radio button for "Do not enable security protections."

![](images/10cloudfront6.png)

after the above step, leave everything as default and click "Create distribution".

vi. After the distribution has been created successfully, click on  "copy policy".


![](images/10cloudfront7.png)



## Step 5 - Attach a Bucket Policy

i. Navigate to the Permissions tab and scroll down to find the "Bucket policy", then click on "edit".

![](images/9bucketpol1.png)

ii. Paste the copied policy in the box and click on save changes.

![](images/9bucketpol2.png)

```

{
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::kool-form-pack/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::533267206451:distribution/E2I5NJS4WGI9FU"
                    }
                }
            }
        ]
      }

```
iii. Return to your CloudFront tab and copy the Distribution domain name. Paste it into your browser's address bar and add "/index.html" to the end. i.e https://d3j2nfd0i0023y.cloudfront.net/index.html.

![](images/10cloudfront7.png)

vi. The link will display your website just like mine below.

![](images/websit.png)

## Conclusion

The outlined process illustrates how to establish a private static website utilizing Amazon S3 and CloudFront. This involves enabling static website hosting with a public read policy on S3, configuring an S3 bucket to store website files, and setting up a CloudFront distribution to ensure global access with optimized transfer rates and minimal latency.

To manage access to the S3 bucket, creating Origin Access Control (OAC) becomes pivotal. Furthermore, the procedure entails making the S3 bucket private by removing any existing public read policies and restricting access solely to the CloudFront service through bucket policy adjustments.

In summary, the documentation demonstrates leveraging CloudFront to strengthen the security and performance of the static website hosted on S3, maintaining privacy and access control solely through the CloudFront distribution.