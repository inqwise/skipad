using System;
using System.Diagnostics;
using System.IO;
using System.Text.RegularExpressions;

namespace Inqwise.Skipad.SystemFramework.VideoEncoder
{
    public class Encoder
    {
        public Encoder(string ffmpegPath)
        {
            this.FFmpegPath = ffmpegPath;
        }

        public const string THUMBNAIL_SUFFIX = "_thumb.jpg";

        public EncodedVideo EncodeVideo(VideoFile input, string encodingCommand, string outputFile, bool getVideoThumbnail, int? threadCount = null)
        {
            var encoded = new EncodedVideo();

            if (threadCount.HasValue)
            {
                Params = string.Format("-i \"{0}\" -movflags faststart -threads {3} {1} \"{2}\"", input.Path, encodingCommand, outputFile, threadCount);
            }
            else
            {
                Params = string.Format("-i \"{0}\" -movflags faststart {1} \"{2}\"", input.Path, encodingCommand, outputFile);
            }
            string output = RunProcess(Params);
            encoded.EncodingLog = output;
            encoded.EncodedVideoPath = outputFile;
            




            if (File.Exists(outputFile))
            {
                encoded.Success = true;

                //get thumbnail?
                if (getVideoThumbnail)
                {
                    string saveThumbnailTo = outputFile + THUMBNAIL_SUFFIX;

                    var encodedInput = new VideoFile(encoded.EncodedVideoPath);

                    if (GetVideoThumbnail(encodedInput, saveThumbnailTo))
                    {
                        encoded.ThumbnailPath = saveThumbnailTo;
                    }
                }
            }
            else
            {
                encoded.Success = false;
            }


            return encoded;

        }
        public bool GetVideoThumbnail(VideoFile input, string saveThumbnailTo)
        {
            if (!input.InfoGathered)
            {
                GetVideoInfo(input);
            }
            int secs;
            //divide the duration in 3 to get a preview image in the middle of the clip
            //instead of a black image from the beginning.
            //secs = (int)Math.Round(TimeSpan.FromTicks(input.Duration.Ticks / 3).TotalSeconds, 0) + new Random().Next(0, Math.Min(2, (int)input.Duration.TotalSeconds));
            secs = (int)Math.Round(TimeSpan.FromTicks(input.Duration.Ticks / 3).TotalSeconds, 0);


            string parameters = string.Format("-ss {0} -i {1} -f image2 -vframes 1 -y {2}", secs, input.Path, saveThumbnailTo);
            //string parameters = string.Format("-i {0} {1} -vcodec mjpeg -ss {2} -vframes 1 -an -f rawvideo", input.Path, saveThumbnailTo, secs);
            string output = RunProcess(parameters);

            if (File.Exists(saveThumbnailTo))
            {
                return true;
            }
            else
            {
                //try running again at frame 1 to get something
                //parameters = string.Format("-i {0} {1} -vcodec mjpeg -ss {2} -vframes 1 -an -f rawvideo", input.Path, saveThumbnailTo, 1);
                parameters = string.Format("-ss {0} -i {1} -f image2 -vframes 1 -y {2}", 1, input.Path, saveThumbnailTo);
                output = RunProcess(parameters);

                return File.Exists(saveThumbnailTo);
            }
        }

        public void GetAudioInfo(AudioFile input)
        {
            string parameters = string.Format("-i {0}", input.Path);
            string output = RunProcess(parameters);
            input.RawInfo = output;
            input.Duration = ExtractDuration(input.RawInfo);
            input.BitRate = ExtractBitrate(input.RawInfo);
            input.RawAudioFormat = ExtractRawAudioFormat(input.RawInfo);
            input.AudioFormat = ExtractAudioFormat(input.RawAudioFormat);
            input.InfoGathered = true;
        }

        public void GetVideoInfo(VideoFile input)
        {
            string parameters = string.Format("-i {0}", input.Path);
            string output = RunProcess(parameters);
            input.RawInfo = output;
            input.Duration = ExtractDuration(input.RawInfo);
            input.BitRate = ExtractBitrate(input.RawInfo);
            input.RawAudioFormat = ExtractRawAudioFormat(input.RawInfo);
            input.AudioFormat = ExtractAudioFormat(input.RawAudioFormat);
            input.RawVideoFormat = ExtractRawVideoFormat(input.RawInfo);
            input.VideoFormat = ExtractVideoFormat(input.RawVideoFormat);
            input.Width = ExtractVideoWidth(input.RawInfo);
            input.Height = ExtractVideoHeight(input.RawInfo);
            input.InfoGathered = true;
        }
        private string RunProcess(string parameters)
        {
            //create a process info
            var oInfo = new ProcessStartInfo(this.FFmpegPath, parameters);
            oInfo.UseShellExecute = false;
            oInfo.CreateNoWindow = true;
            oInfo.RedirectStandardOutput = true;
            oInfo.RedirectStandardError = true;

            //Create the output and streamreader to get the output
            string output = null; StreamReader srOutput = null;

            //try the process
            try
            {
                //run the process
                Process proc = System.Diagnostics.Process.Start(oInfo);

                //get the output
                srOutput = proc.StandardError;

                //now put it in a string
                output = srOutput.ReadToEnd();
                
                proc.WaitForExit();
                proc.Close();
            }
            catch (Exception)
            {
                output = string.Empty;
            }
            finally
            {
                //now, if we succeded, close out the streamreader
                if (srOutput != null)
                {
                    srOutput.Close();
                    srOutput.Dispose();
                }
            }
            return output;
        }
        public string FFmpegPath { get; set; }
        private string Params { get; set; }
        private TimeSpan ExtractDuration(string rawInfo)
        {
            TimeSpan t = new TimeSpan(0);
            Regex re = new Regex("[D|d]uration:.((\\d|:|\\.)*)", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);

            if (m.Success)
            {
                string duration = m.Groups[1].Value;
                string[] timepieces = duration.Split(new char[] { ':', '.' });
                if (timepieces.Length == 4)
                {
                    t = new TimeSpan(0, Convert.ToInt16(timepieces[0]), Convert.ToInt16(timepieces[1]), Convert.ToInt16(timepieces[2]), Convert.ToInt16(timepieces[3]));
                }
            }

            return t;
        }
        private double ExtractBitrate(string rawInfo)
        {
            Regex re = new Regex("[B|b]itrate:.((\\d|:)*)", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);
            double kb = 0.0;
            if (m.Success)
            {
                Double.TryParse(m.Groups[1].Value, out kb);
            }
            return kb;
        }
        private string ExtractRawAudioFormat(string rawInfo)
        {
            string a = string.Empty;
            Regex re = new Regex("[A|a]udio:.*", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);
            if (m.Success)
            {
                a = m.Value;
            }
            return a.Replace("Audio: ", "");
        }
        private string ExtractAudioFormat(string rawAudioFormat)
        {
            string[] parts = rawAudioFormat.Split(new string[] { ", " }, StringSplitOptions.None);
            return parts[0].Replace("Audio: ", "");
        }
        private string ExtractRawVideoFormat(string rawInfo)
        {
            string v = string.Empty;
            Regex re = new Regex("[V|v]ideo:.*", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);
            if (m.Success)
            {
                v = m.Value;
            }
            return v.Replace("Video: ", ""); ;
        }
        private string ExtractVideoFormat(string rawVideoFormat)
        {
            string[] parts = rawVideoFormat.Split(new string[] { ", " }, StringSplitOptions.None);
            return parts[0].Replace("Video: ", "");
        }
        private int ExtractVideoWidth(string rawInfo)
        {
            int width = 0;
            Regex re = new Regex("(\\d{2,4})x(\\d{2,4})", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);
            if (m.Success)
            {
                int.TryParse(m.Groups[1].Value, out width);
            }
            return width;
        }
        private int ExtractVideoHeight(string rawInfo)
        {
            int height = 0;
            Regex re = new Regex("(\\d{2,4})x(\\d{2,4})", RegexOptions.Compiled);
            Match m = re.Match(rawInfo);
            if (m.Success)
            {
                int.TryParse(m.Groups[2].Value, out height);
            }
            return height;
        }
    }
}