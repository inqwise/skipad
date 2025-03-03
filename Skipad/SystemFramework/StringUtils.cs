namespace Inqwise.Skipad.SystemFramework
{
    public static class StringUtils
    {
        public static string TrimToNull(this string str)
        {
            var output = string.IsNullOrEmpty(str) ? null :str.Trim();
            return string.IsNullOrEmpty(output) ? null : output;
        }
    }
}