using System;

namespace Inqwise.Skipad.SystemFramework.VideoEncoder
{
    public class VideoFile : AudioFile
    {
        public VideoFile(string path) : base(path)
        {
        }

        public string RawVideoFormat { get; set; }
        public string VideoFormat { get; set; }
        public int Height { get; set; }
        public int Width { get; set; }
    }
}