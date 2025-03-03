using System;
using System.IO;

namespace Inqwise.Skipad.SystemFramework.VideoEncoder
{
    public class AudioFile
    {
        public string Path { get; set; }
        public double BitRate { get; set; }
        public string RawAudioFormat { get; set; }
        public string AudioFormat { get; set; }
        public string RawInfo { get; set; }
        public bool InfoGathered { get; set; }
        public TimeSpan Duration { get; set; }
        
        public AudioFile(string path)
        {
            Path = path;
            Initialize();
        }

        protected void Initialize()
        {
            this.InfoGathered = false;
            if (string.IsNullOrEmpty(Path))
            {
                throw new Exception("File Path not set or empty.");
            }
            if (!File.Exists(Path))
            {
                throw new Exception("The file " + Path + " does not exist.");
            }
        }
    }
}