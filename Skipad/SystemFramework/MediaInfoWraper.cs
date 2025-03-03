using System;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;

namespace Inqwise.Skipad.SystemFramework
{
    public class MediaInfoWrapper : IDisposable
    {
        #region Proteted fields & constants

        protected const int MEDIAINFO_FILE_OPENED = 1;

        protected MediaInfo _mediaInfo;
        protected bool _isValid = false;

        #endregion

        public MediaInfoWrapper()
        {
            _mediaInfo = new MediaInfo();
            _isValid = false;
        }

        public bool IsValid
        {
            get { return _isValid; }
        }

        public void Dispose()
        {
            if (_isValid)
                Close();
        }

        #region Protected methods

        protected static int? GetIntOrNull(string strValue)
        {
            if (string.IsNullOrEmpty(strValue))
                return null;
            int result;
            return int.TryParse(strValue, out result) ? result : new int?();
        }

        protected static long? GetLongOrNull(string strValue)
        {
            if (string.IsNullOrEmpty(strValue))
                return null;
            long result;
            return long.TryParse(strValue, out result) ? result : new long?();
        }

        protected static float? GetFloatOrNull(string strValue)
        {
            if (string.IsNullOrEmpty(strValue))
                return null;
            float result;
            return float.TryParse(strValue, NumberStyles.Float, CultureInfo.InvariantCulture, out result)
                       ? result
                       : new float?();
        }

        #endregion

        public bool Open(string filePath)
        {
            _isValid = _mediaInfo.Open(filePath) == MEDIAINFO_FILE_OPENED;
            return _isValid;
        }

        public bool Open(Stream stream)
        {
            _isValid = (_mediaInfo.Open_Buffer_Init(stream.Length, 0) == MEDIAINFO_FILE_OPENED);
            if (!_isValid)
                return false;

            // Increased buffer size for some .mp4 that contain first audio, then video stream. If buffer is smaller (i.e. 64 kb),
            // MediaInfo only detects the audio stream. It works correctly in file mode.
            const int bufferSize = 512*1024;
            byte[] buffer = new byte[bufferSize]; // init the buffer to communicate with MediaInfo
            GCHandle gcHandle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
            IntPtr bufferPtr = gcHandle.AddrOfPinnedObject();
            try
            {
                // Now we need to run the parsing loop, as long as MediaInfo requests information from the stream
                int bytesRead;
                do
                {
                    bytesRead = stream.Read(buffer, 0, bufferSize);

                    if ((_mediaInfo.Open_Buffer_Continue(bufferPtr, (IntPtr) bytesRead) & BufferResult.Finalized) ==
                        BufferResult.Finalized)
                        // MediaInfo doesn't need more information from us
                        break;

                    long newPos = _mediaInfo.Open_Buffer_Continue_GoTo_Get();
                    // Now we need to test, if MediaInfo wants data from a different place of the stream
                    if (newPos == -1)
                        break;
                    Int64 pos = stream.Seek(newPos, SeekOrigin.Begin); // Position the stream
                    _mediaInfo.Open_Buffer_Init(stream.Length, pos); // Inform MediaInfo that we are at the new position
                } while (bytesRead > 0);
            }
            finally
            {
                gcHandle.Free();

                // Finalising MediaInfo procesing
                _mediaInfo.Open_Buffer_Finalize();
            }
            return _isValid;
        }

        public void Close()
        {
            _mediaInfo.Close();
            _isValid = false;
        }

        public int GetVideoCount()
        {
            int result;
            return int.TryParse(_mediaInfo.Get(StreamKind.Video, 0, "StreamCount"), out result) ? result : 0;
        }

        public string GetVidCodec(int stream)
        {
            return StringUtils.TrimToNull(_mediaInfo.Get(StreamKind.Video, stream, "CodecID/Hint")) ??
                   StringUtils.TrimToNull(_mediaInfo.Get(StreamKind.Video, stream, "Codec/String"));
        }

        public long? GetVidBitrate(int stream)
        {
            return GetLongOrNull(_mediaInfo.Get(StreamKind.Video, stream, "BitRate"));
        }

        public int? GetWidth(int stream)
        {
            return GetIntOrNull(_mediaInfo.Get(StreamKind.Video, stream, "Width"));
        }

        public int? GetHeight(int stream)
        {
            return GetIntOrNull(_mediaInfo.Get(StreamKind.Video, stream, "Height"));
        }

        public float? GetAR(int stream)
        {
            return GetFloatOrNull(_mediaInfo.Get(StreamKind.Video, stream, "AspectRatio"));
        }

        public long? GetPlaytime(int stream)
        {
            return GetLongOrNull(_mediaInfo.Get(StreamKind.Video, stream, "PlayTime"));
        }

        public int? GetFramerate(int stream)
        {
            return GetIntOrNull(_mediaInfo.Get(StreamKind.Video, stream, "FrameRate"));
        }

        public int GetAudioCount()
        {
            int result;
            return int.TryParse(_mediaInfo.Get(StreamKind.Audio, 0, "StreamCount"), out result) ? result : 0;
        }

        public string GetAudioCodec(int stream)
        {
            return StringUtils.TrimToNull(_mediaInfo.Get(StreamKind.Audio, stream, "CodecID/Hint")) ??
                   StringUtils.TrimToNull(_mediaInfo.Get(StreamKind.Audio, stream, "Codec/String"));
        }

        public string GetAudioLanguage(int stream)
        {
            string lang2 = StringUtils.TrimToNull(_mediaInfo.Get(StreamKind.Audio, stream, "Language/String2"));
            if (lang2 == null)
                return null;
            try
            {
                CultureInfo cultureInfo = new CultureInfo(lang2);
                return cultureInfo.TwoLetterISOLanguageName;
            }
            catch (ArgumentException)
            {
                return null;
            }
        }

        public long? GetAudioBitrate(int stream)
        {
            return GetLongOrNull(_mediaInfo.Get(StreamKind.Audio, stream, "BitRate"));
        }

        // TODO: (cover art, ....)
    }
}