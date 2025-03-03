using System;
using System.Linq;
using System.Diagnostics;
using System.IO;
using System.Configuration;
using Inqwise.Skipad.SystemFramework.VideoEncoder;

namespace Inqwise.Skipad.SystemFramework
{
    /// <summary>
    /// Summary description for VideoProcess
    /// </summary>
    public class VideoProcess
    {
        public const string FILENAME_FORMAT = "{0}_{1}x{2}x{3}x{4:x2}.{5}"; //{namePrefix}_{width}x{height}x{bitrate}x{timestamp}.{extension}
        public const string MP4_EXTENSION_NAME = "mp4";
        public const string MP4_CONTENT_TYPE = "video/mp4";

        public struct VideoProcessResult
        {
            public string Path;
            public string FileName;
            public string Extension;
            public string ContentType;
            public int Height;
            public int Width;
            public int Bitrate;
            public string ThumbnailPath;
            public TimeSpan Duration;
        }

        private static readonly string FfmpegPath = ConfigurationManager.AppSettings["FFMpegPath"];
        

        public string NamePrefix { get; private set; }
        public Encoder Encoder { get; private set; }
        public VideoFile VideoFile { get; private set; }

        public VideoProcess(string path, string namePrefix)
        {
            NamePrefix = namePrefix;
            VideoFile = new VideoFile(path);
            Encoder = new Encoder(FfmpegPath);
            Encoder.GetVideoInfo(VideoFile);
        }

        public VideoProcessResult ConvertAndSaveMp4(Tuple<int, int, int> transform, string outputFolder)
        {
            string fileName = string.Format(FILENAME_FORMAT, NamePrefix, transform.Item1,
                                     transform.Item2, transform.Item3, DateTime.Now.Ticks, MP4_EXTENSION_NAME);
            var outputFilePath = Path.Combine(outputFolder,
                                              fileName);
            var encodedVideo = Encoder.EncodeVideo(VideoFile, GetEncodingCommand(transform), outputFilePath, true);

            if (!encodedVideo.Success)
            {
                throw new Exception("ConvertAndSaveMp4 failed, Log:" + encodedVideo.EncodingLog);
            }

            return new VideoProcessResult
                {
                    ContentType = MP4_CONTENT_TYPE,
                    Extension = MP4_EXTENSION_NAME,
                    FileName = fileName,
                    Width = transform.Item1,
                    Height = transform.Item2,
                    Bitrate = transform.Item3,
                    Path = encodedVideo.EncodedVideoPath,
                    ThumbnailPath = encodedVideo.ThumbnailPath,
                    Duration = VideoFile.Duration,
                };
        }

        private string GetEncodingCommand(Tuple<int, int, int> transform)
        {
            return string.Format("-b:v {2}k -s:v {0}x{1} -f mp4", transform.Item1, transform.Item2, transform.Item3);
        }

        private void Run(string inputFile, string fileName)
        {
            string[] sizes = ConfigurationManager.AppSettings["VideoSizes"].Split(';');
            string[] bitrates = ConfigurationManager.AppSettings["VideoBitrates"].Split(';');

            var runResults = sizes.Select((size, i) => RunVideo(inputFile, size, bitrates[i], ConfigurationManager.AppSettings["ResoucesFolder"] + fileName + "_" + sizes[i] + ".mp4")).AsParallel().ToList();
        }

        private bool RunVideo(string inputFile, string size, string bitrate, string outputFile)
        {
            string ffmpegParams = "-i \"" + inputFile;
            ffmpegParams += "\" -s:v " + size;
            ffmpegParams += " -b:v " + bitrate + "k";
            ffmpegParams += " \"" +  outputFile + "\"";

            string output = RunProcess(FfmpegPath, ffmpegParams);

            return !string.IsNullOrEmpty(output) ;
        }

        private string RunProcess(string ffmpegPath, string Parameters)
        {
            //create a process info
            ProcessStartInfo oInfo = new ProcessStartInfo(ffmpegPath, Parameters);
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
            catch (Exception ex)
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

        public static Encoder GetEncoder()
        {
            return new Encoder(FfmpegPath);
        }
    }
}