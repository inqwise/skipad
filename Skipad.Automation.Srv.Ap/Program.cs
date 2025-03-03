using System;
using System.Configuration;
using System.ServiceProcess;

namespace Inqwise.Skipad.Automation.Service
{
    internal class Program
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
        internal static void Main(string[] args)
        {
            bool runAsService;
            var strRunAsService = ConfigurationManager.AppSettings["RunAsService"];
            if (string.IsNullOrEmpty(strRunAsService) || !bool.TryParse(strRunAsService, out runAsService) ||
                runAsService)
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[]
                {
                    new AutomationService()
                };
                ServiceBase.Run(ServicesToRun);
            }
            else
            {
                Console.WriteLine("Executed as Console");
                var service = new AutomationService();
                service.StartService();
                Console.WriteLine("Press ay key to stop ...");
                Console.ReadKey();
                service.StopService();
            }
        }
    }
}
