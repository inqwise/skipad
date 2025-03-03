using System;
using Amazon.Runtime;
using Amazon.S3;
using Inqwise.Skipad.Automation.Managers;
using Quartz;
using Quartz.Impl;

namespace Inqwise.Skipad.Automation.Jobs
{
    [DisallowConcurrentExecution]
    public class SkipadEventsJob : IJob
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        public void Execute(IJobExecutionContext context)
        {
            Log.Debug("SkipadEventsJob executed");
            try
            {
                if (SkipadEventsManager.HandleSingleS3Object())
                {
                    context.Scheduler.TriggerJob(context.JobDetail.Key);
                }
            }
            catch (AmazonServiceException aex)
            {
                if (aex is AmazonS3Exception && aex.ErrorCode.Equals("NoSuchKey"))
                {
                    Log.Info(
                        "SkipadRequestsJob: Key already deleted. ErrorCode: '{0}', RequestId: '{1}', StatusCode: '{2}'",
                        aex.ErrorCode, aex.RequestId, aex.StatusCode);
                }
                else
                {
                    Log.ErrorException(
                        String.Format(
                            "SkipadEventsJob: Unexpected AmazonService error occured. ErrorCode: '{0}', RequestId: '{1}', StatusCode: '{2}'",
                            aex.ErrorCode, aex.RequestId, aex.StatusCode), aex);
                    throw;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                Log.ErrorException("SkipadEventsJob: Unexpected error occured", ex);
                throw;
            }
        }

        
    }
}