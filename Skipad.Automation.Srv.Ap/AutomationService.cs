using System;
using System.ServiceProcess;
using Inqwise.Skipad.Automation.Managers;

namespace Inqwise.Skipad.Automation.Service
{
    public class AutomationService : ServiceBase
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        public AutomationService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            StartService();
        }

        protected override void OnStop()
        {
            StopService();
        }

        public void StartService()
        {
            Log.Debug("Start Service");
            try
            {
                JobsManager.Instance.Start();
                Log.Info("Automation service has been started");
            }
            catch (Exception ex)
            {
                Log.FatalException("Failed to start service", ex);
                throw;
            }
        }

        public void StopService()
        {
            Log.Debug("Stop Service");
            try
            {
                JobsManager.Instance.Stop();
                Log.Info("Automation service has been stopped");
            }
            catch (Exception ex)
            {
                Log.FatalException("Failed to Stop service", ex);
                throw;
            }
        }

        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            this.ServiceName = "AutomationService";
        }

    }
}
