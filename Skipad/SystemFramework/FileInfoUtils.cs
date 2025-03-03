using System;
using System.IO;
using System.Runtime.InteropServices;

namespace Inqwise.Skipad.SystemFramework

{
    public class FileInfoUtils
    {
        [DllImport("urlmon.dll", CharSet = CharSet.Unicode, ExactSpelling = true, SetLastError = false)]
        static extern int FindMimeFromData(IntPtr pBC,
              [MarshalAs(UnmanagedType.LPWStr)] string pwzUrl,
             [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.I1, SizeParamIndex = 3)] 
        byte[] pBuffer,
              int cbSize,
                 [MarshalAs(UnmanagedType.LPWStr)]  string pwzMimeProposed,
              int dwMimeFlags,
              out IntPtr ppwzMimeOut,
              int dwReserved);

        public static string GetMimeFromFile(string filename)
        {
            if (!File.Exists(filename))
                throw new FileNotFoundException(filename + " not found");

            byte[] buffer = new byte[256];
            using (var fs = new FileStream(filename, FileMode.Open))
            {
                if (fs.Length >= 256)
                    fs.Read(buffer, 0, 256);
                else
                    fs.Read(buffer, 0, (int)fs.Length);
            }

            return GetMimeFromBuffer(buffer);
        }

        public static string GetMimeFromBuffer(byte[] buffer)
        {
            try
            {
                //System.UInt32 mimetype;
                IntPtr mimeTypePtr;
                FindMimeFromData(new IntPtr(0), null, buffer, 256, null, 0, out mimeTypePtr, 0);
                //IntPtr mimeTypePtr = new IntPtr(mimetype);
                string mime = Marshal.PtrToStringUni(mimeTypePtr);
                Marshal.FreeCoTaskMem(mimeTypePtr);
                return mime;
            }
            catch (Exception e)
            {
                return "unknown/unknown";
            }
        }
    }
}