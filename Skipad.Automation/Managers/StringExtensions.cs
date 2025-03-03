namespace Inqwise.Skipad.Automation.Managers
{
    public static class StringExtensions
    {
        public static string[] SplitOrDefault(this string s, string[] defaultValue = null)
        {
            return null == s ? defaultValue : s.Split(',');
        }
    }
}