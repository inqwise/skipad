using System;
using System.Configuration;
using Inqwise.Skipad.Automation.Jobs;
using Quartz;
using Quartz.Impl;

namespace Inqwise.Skipad.Automation.Managers
{
    public class JobsManager
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        private IScheduler _scheduler;
        private static readonly Lazy<JobsManager> _instance = new Lazy<JobsManager>();

        public static JobsManager Instance 
        {
            get { return _instance.Value; }
        }

        public void Start()
        {
            ISchedulerFactory schedulerFactory = new StdSchedulerFactory();
            _scheduler = schedulerFactory.GetScheduler();

            AddSkipadEventJob();

            _scheduler.Start();
        }

        private void AddSkipadEventJob()
        {
            IJob eventsJob = new SkipadEventsJob();
            var eventsJobDetail = new JobDetailImpl("SkipadEventsJob", "SkipadJobGroup", eventsJob.GetType(), false, false);
            var eventsJobTriggerBuilder = TriggerBuilder.Create()
                          .ForJob(eventsJobDetail)
                          .WithCronSchedule(ConfigurationManager.AppSettings["SkipadEventsJob:CronExpression"]);
            _scheduler.ScheduleJob(eventsJobDetail, eventsJobTriggerBuilder.Build());

            var eventsTriggerNow = TriggerBuilder.Create()
                .ForJob(eventsJobDetail)
                .StartNow()
                .Build();
            _scheduler.ScheduleJob(eventsTriggerNow);

            IJob requestsJob = new SkipAdRequestsJob();
            var requestsJobDetail = new JobDetailImpl("SkipadRequestsJob", "SkipadJobGroup", requestsJob.GetType(), false, false);
            var requestsJobTriggerBuilder = TriggerBuilder.Create()
                          .ForJob(requestsJobDetail)
                          .WithCronSchedule(ConfigurationManager.AppSettings["SkipadRequestsJob:CronExpression"]);
            _scheduler.ScheduleJob(requestsJobDetail, requestsJobTriggerBuilder.Build());

            var requestsTriggerNow = TriggerBuilder.Create()
                .ForJob(requestsJobDetail)
                .StartNow()
                .Build();
            _scheduler.ScheduleJob(requestsTriggerNow);
        }

        public void Stop()
        {
            if (null != _scheduler)
            {
                _scheduler.Shutdown(true);
                _scheduler = null;
            }
        }
    }
}