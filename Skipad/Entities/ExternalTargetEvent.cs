using System;
using System.Data;
using Inqwise.Skipad.Common;

namespace Inqwise.Skipad.Entities
{
    public class ExternalTargetEvent : IExternalTargetEvent
    {
        public string Url { get; private set; }
        public int EventTypeId { get; private set; }

        public ExternalTargetEvent(IDataReader reader)
        {
            Url = reader["URL"].ToString();
            EventTypeId = Convert.ToInt32(reader["EventTypeId"]);
        }
    }
}