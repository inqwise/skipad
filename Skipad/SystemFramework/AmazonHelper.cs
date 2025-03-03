using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using Amazon.S3;
using Amazon.S3.Model;

namespace Inqwise.Skipad.SystemFramework
{
    public class AmazonHelper : IDisposable
    {
        private static bool CheckValidationResult(object sender, X509Certificate cert, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        static AmazonHelper()
        {
            ServicePointManager.ServerCertificateValidationCallback = CheckValidationResult;
        }

        private readonly string _accessKeyId = "";
        private readonly string _secretAccessKeyId = "";
        private readonly string _bucketName = "";
        private IAmazonS3 _storage = null;
        private object _storageLocker = new object();
        private int _storageGetCounter = 0;
        private IAmazonS3 GetStorage()
        {
            /*
            var config = new AmazonS3Config
            {
                ServiceURL = "http://s3.amazonaws.com",
                ReadWriteTimeout = TimeSpan.FromSeconds(30),
            };
            return  Amazon.AWSClientFactory.CreateAmazonS3Client(_accessKeyId, _secretAccessKeyId, config);
            */


            if (null == _storage)
            {
                lock (_storageLocker)
                {
                    if (null == _storage)
                    {
                        var config = new AmazonS3Config
                        {
                            ServiceURL = "http://s3.amazonaws.com",
                            ReadWriteTimeout = TimeSpan.FromSeconds(30),
                            ConnectionLimit = 100,
                        };
                        _storage = Amazon.AWSClientFactory.CreateAmazonS3Client(_accessKeyId, _secretAccessKeyId, config);
                    }
                }
            }

            return _storage;

        }


        public AmazonHelper()
            : this(ConfigurationManager.AppSettings["AWSBucketName"])
        {

        }

        public AmazonHelper(string bucketName, string accessKeyId = null, string secretAccessKeyId = null)
        {
            if (null == bucketName) throw new ArgumentNullException("bucketName");
            this._accessKeyId = accessKeyId ?? ConfigurationManager.AppSettings["AWSAccessKey"];
            this._secretAccessKeyId = secretAccessKeyId ?? ConfigurationManager.AppSettings["AWSSecretKey"];
            this._bucketName = bucketName;
        }

        public void BeginUpload(Stream s, string filename, string contentType, AsyncCallback callback)
        {
            try
            {
                using (var storage = GetStorage())
                {
                    var request = new PutObjectRequest();
                    request.BucketName = _bucketName;
                    request.Key = filename;
                    request.ContentType = contentType;
                    request.InputStream = s;
                    request.StorageClass = (ConfigurationManager.AppSettings["AWSReducedRedundancy"] == "true"
                                                ? S3StorageClass.ReducedRedundancy
                                                : S3StorageClass.Standard);
                    request.CannedACL = S3CannedACL.PublicRead;
                    //request.Timeout = TimeSpan.FromMinutes(1);

                    storage.BeginPutObject(request, callback, null);
                }
            }
            catch (AmazonS3Exception amazonS3Exception)
            {
                if (amazonS3Exception.ErrorCode != null &&
                    (amazonS3Exception.ErrorCode.Equals("InvalidAccessKeyId") ||
                     amazonS3Exception.ErrorCode.Equals("InvalidSecurity")))
                {
                    throw new Exception(
                        "Please check the provided AWS Credentials. If you haven't signed up for Amazon S3, please visit http://aws.amazon.com/s3");
                }
                else
                {
                    _storage = null;
                    throw;
                }
            }
        }

        public bool Upload(Stream s, string filename, string contentType)
        {
            {
                try
                {
                    using (var storage = GetStorage())
                    {
                        var request = new PutObjectRequest();
                        request.BucketName = _bucketName;
                        request.Key = filename;
                        request.ContentType = contentType;
                        request.InputStream = s;
                        request.StorageClass = (ConfigurationManager.AppSettings["AWSReducedRedundancy"] == "true"
                                                    ? S3StorageClass.ReducedRedundancy
                                                    : S3StorageClass.Standard);
                        request.CannedACL = S3CannedACL.PublicRead;
                        //request.Timeout = TimeSpan.FromMinutes(1);

                        var response = storage.PutObject(request);
                    }
                    return true;
                }
                catch (AmazonS3Exception amazonS3Exception)
                {
                    if (amazonS3Exception.ErrorCode != null &&
                        (amazonS3Exception.ErrorCode.Equals("InvalidAccessKeyId") ||
                         amazonS3Exception.ErrorCode.Equals("InvalidSecurity")))
                    {
                        throw new Exception(
                            "Please check the provided AWS Credentials. If you haven't signed up for Amazon S3, please visit http://aws.amazon.com/s3");
                    }
                    else
                    {
                        _storage = null;
                        throw;
                    }
                }
            }
        }

        public bool Delete(string filename)
        {
            if (null != filename)
            {
                try
                {
                    var request = new DeleteObjectRequest();
                    request.BucketName = _bucketName;
                    request.Key = filename;
                    using (var storage = GetStorage())
                    {
                        storage.DeleteObject(request);
                    }

                    return true;
                }
                catch (AmazonS3Exception amazonS3Exception)
                {
                    if (amazonS3Exception.ErrorCode != null &&
                        (amazonS3Exception.ErrorCode.Equals("InvalidAccessKeyId") ||
                            amazonS3Exception.ErrorCode.Equals("InvalidSecurity")))
                    {
                        throw new Exception(
                            "Please check the provided AWS Credentials. If you haven't signed up for Amazon S3, please visit http://aws.amazon.com/s3");
                    }
                    else
                    {
                        throw amazonS3Exception;
                    }
                }
            }

            return false;
        }

        public void Dispose()
        {
            //if (null != _storage) _storage.Dispose();
        }
    }

}