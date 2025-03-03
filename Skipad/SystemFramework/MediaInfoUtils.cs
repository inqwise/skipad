using System;
using System.IO;
using System.Net;

namespace Inqwise.Skipad.SystemFramework
{
    public struct MediaInfoVideoDetails
    {
        public int? Height { get; set; }
    }

    public class MediaInfoUtils
    {
        public static MediaInfoVideoDetails GetVideoDetailsFromUrl(string remoteFilename)
        {
            MediaInfoVideoDetails details;
            //Initilaizing MediaInfo

            //inputStream: preparing an example file for reading
            Stream remoteStream = null;
            WebResponse response = null;
            try
            {
                // Create a request for the specified remote file name
                WebRequest request = WebRequest.Create(remoteFilename);
                // Send the request to the server and retrieve the
                // WebResponse object
                response = request.GetResponse();
                {
                    // Once the WebResponse object has been retrieved,
                    // get the stream object associated with the response's data
                    remoteStream = response.GetResponseStream();
                    using (var mi = new MediaInfoWrapper())
                    {
                        mi.Open(remoteStream);
                        details = new MediaInfoVideoDetails { Height = mi.GetHeight(0) };
                        mi.Close();
                    }
                }
            }
            finally
            {
                // Close the response and streams objects here
                // to make sure they're closed even if an exception
                // is thrown at some point
                if (response != null) response.Close();
                if (remoteStream != null) remoteStream.Close();
            }

            return details;
        }

        /*
        public static MediaInfoVideoDetails GetVideoDetailsFromStream(Stream inputStream)
        {
            var MI = new MediaInfo();
            //inputStream: preparing a memory buffer for reading
            byte[] fromBuffer = new byte[64*1024];
            int fromBufferSize; //The size of the read file buffer

            //Preparing to fill MediaInfo with a buffer
            MI.Open_Buffer_Init(inputStream.Length, 0);

            //The parsing loop
            do
            {
                //Reading data somewhere, do what you want for this.
                fromBufferSize = inputStream.Read(fromBuffer, 0, 64*1024);

                //Sending the buffer to MediaInfo
                System.Runtime.InteropServices.GCHandle gc = System.Runtime.InteropServices.GCHandle.Alloc(fromBuffer,
                                                                                                           System.Runtime
                                                                                                                 .InteropServices
                                                                                                                 .GCHandleType
                                                                                                                 .Pinned);
                IntPtr fromBufferIntPtr = gc.AddrOfPinnedObject();
                if (MI.Open_Buffer_Continue(fromBufferIntPtr, (IntPtr) fromBufferSize) == 0)
                    //Note: How to provide a buffer[]?
                {
                    gc.Free();
                    break;
                }
                gc.Free();


                do
                {
                    byte[] buf = new byte[1024];
                    count = stream.Read(buf, 0, 1024);
                    ms.Write(buf, 0, count);
                } while (stream.CanRead && count > 0);

                //Testing if MediaInfo request to go elsewhere
                if (MI.Open_Buffer_Continue_GoTo_Get() != -1)
                {
                    Int64 position = inputStream.Seek(MI.Open_Buffer_Continue_GoTo_Get(), SeekOrigin.Begin); //Position the file
                    MI.Open_Buffer_Init(inputStream.Length, position); //Informing MediaInfo we have seek
                }

            } while (fromBufferSize > 0);

            //Finalizing
            MI.Open_Buffer_Finalize(); //This is the end of the stream, MediaInfo must finnish some work

            //Get() example

            //var length = mediaInfo.Get(StreamKind.Video, 0, "Duration/String3");

            var result = new MediaInfoVideoDetails
            {
                Format = MI.Get(StreamKind.General, 0, "Format"),
            };

            return result;
        }*/
    }
}