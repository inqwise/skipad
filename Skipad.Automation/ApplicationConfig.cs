using System;
using System.Configuration;

namespace Inqwise.Skipad.Automation
{
    public static class ApplicationConfig
    {
        public static class Amazon
        {
            public static readonly Lazy<string> AccessKey = new Lazy<string>(() => ConfigurationManager.AppSettings["AWS:S3:AccessKey"]);
            public static readonly Lazy<string> SecretKey = new Lazy<string>(() => ConfigurationManager.AppSettings["AWS:S3:SecretKey"]);
            public static readonly Lazy<string> BuckletName = new Lazy<string>(() => ConfigurationManager.AppSettings["AWS:S3:BuckletName"]);
            public static readonly Lazy<string> EventsPrefix = new Lazy<string>(() => ConfigurationManager.AppSettings["AWS:S3:EventsPrefix"]);
            public static readonly Lazy<string> RequestsPrefix = new Lazy<string>(() => ConfigurationManager.AppSettings["AWS:S3:RequestsPrefix"]);
        }
    }
}