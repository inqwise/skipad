using System;
using System.Collections.Generic;
using System.Linq;
using Jayrock.Json;
using Inqwise.Skipad.SystemFramework;

namespace Handlers
{
    public static class JsonObjectExtensions
    {
        public static int? OptInt(this JsonObject o, string key, int? defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : Convert.ToInt32(obj) as int?;
        }

        public static object Opt(this JsonObject o, string key, object defaultValue)
        {
            if (o.Contains(key))
            {
                return o[key];
            }

            return defaultValue;
        }

        public static string OptString(this JsonObject o, string key, string defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : obj.ToString();
        }

        public static string OptStringTrim(this JsonObject o, string key, string defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : obj.ToString().TrimToNull();
        }

        public static bool? OptBool(this JsonObject o, string key, bool? defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : Convert.ToBoolean(obj);
        }

        public static DateTime? OptDate(this JsonObject o, string key, DateTime? defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : DateTime.ParseExact(obj.ToString(), "yyyy-MM-dd HH:mm", null);
        }

        public static IEnumerable<long> GetMenyLong(this JsonObject o, string key)
        {
            var arr = (JsonArray) o[key];
            return arr.Select(Convert.ToInt64);
        }

        public static IEnumerable<long> OptMenyLong(this JsonObject o, string key)
        {
            var arr = (JsonArray)o[key];
            return null == arr ? null : arr.Select(Convert.ToInt64);
        }

        public static int GetInt(this JsonObject o, string key)
        {
            return Convert.ToInt32(o[key]);
        }

        public static IEnumerable<int> GetMenyInt(this JsonObject o, string key)
        {
            var arr = (JsonArray) o[key];
            return arr.Select(Convert.ToInt32);
        }

        public static IEnumerable<int> OptMenyInt(this JsonObject o, string key)
        {
            var arr = (JsonArray)o[key];
            return null == arr ?  null : arr.Select(Convert.ToInt32);
        }

        public static string GetString(this JsonObject o, string key)
        {
            return o.Contains(key) ? Convert.ToString(o[key]) : null;
        }

        public static long GetLong(this JsonObject o, string key)
        {
            return Convert.ToInt64(o[key]);
        }

        public static bool GetBool(this JsonObject o, string key)
        {
            return Convert.ToBoolean(o[key]);
        }

        public static long? OptLong(this JsonObject o, string key, long? defaultValue = null)
        {
            var obj = Opt(o, key, defaultValue);
            return null == obj ? defaultValue : Convert.ToInt64(obj) as long?;
        }

    }
}