using System;
using System.Configuration;
using Amazon.Runtime;
using Amazon.StorageGateway;
using Inqwise.Skipad.Automation.Managers;
using Quartz;
using Quartz.Impl;
using Amazon.S3;

namespace Inqwise.Skipad.Automation.Jobs
{

    [DisallowConcurrentExecution]
    public class SkipAdRequestsJob : IJob
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        public void Execute(IJobExecutionContext context)
        {
            Log.Debug("SkipadRequestsJob executed");
            try
            {
                if (SkipadRequestsManager.HandleSingleS3Object())
                {
                    context.Scheduler.TriggerJob(context.JobDetail.Key);
                }
            }
            catch (AmazonServiceException aex)
            {
                if (aex is AmazonS3Exception && aex.ErrorCode.Equals("NoSuchKey"))
                {
                    Log.Info("SkipadRequestsJob: Key already deleted. ErrorCode: '{0}', RequestId: '{1}', StatusCode: '{2}'", aex.ErrorCode, aex.RequestId, aex.StatusCode);
                }
                else
                {
                    Log.ErrorException(String.Format("SkipadRequestsJob: Unexpected AmazonService error occured. ErrorCode: '{0}', RequestId: '{1}', StatusCode: '{2}'", aex.ErrorCode, aex.RequestId, aex.StatusCode), aex);
                    throw;
                }
            }
            catch (Exception ex)
            {
                Log.ErrorException("SkipadRequestsJob: Unexpected error occured", ex);
                throw;
            }
        }
    }
}