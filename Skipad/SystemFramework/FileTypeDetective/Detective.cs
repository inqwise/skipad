using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Inqwise.Skipad.SystemFramework.FileTypeDetective
{
    /// <summary>
    /// Helper class to identify file type by the file header, not file extension.
    /// </summary>
    public static class Detective
    {
        private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

        #region Constants

        // file headers are taken from here:
        //http://www.garykessler.net/library/file_sigs.html
        //mime types are taken from here:
        //http://www.webmaster-toolkit.com/mime-types.shtml
        
        // MS Office files
        public readonly static FileType WORD = new FileType(new byte?[] { 0xEC, 0xA5, 0xC1, 0x00 }, 512, "doc", "application/msword", MimeType.Document);
        public readonly static FileType EXCEL = new FileType(new byte?[] { 0x09, 0x08, 0x10, 0x00, 0x00, 0x06, 0x05, 0x00 }, 512, "xls", "application/excel", MimeType.Document);
        public readonly static FileType PPT = new FileType(new byte?[] { 0xFD, 0xFF, 0xFF, 0xFF, null, 0x00, 0x00, 0x00 }, 512, "ppt", "application/mspowerpoint", MimeType.Document);
        
        // common documents
        public readonly static FileType RTF = new FileType(new byte?[] { 0x7B, 0x5C, 0x72, 0x74, 0x66, 0x31 }, "rtf", "application/rtf", MimeType.Document);
        public readonly static FileType PDF = new FileType(new byte?[] { 0x25, 0x50, 0x44, 0x46 }, "pdf", "application/pdf", MimeType.Document);
        
        // grafics
        public readonly static FileType JPEG = new FileType(new byte?[] { 0xFF, 0xD8, 0xFF }, "jpg", "image/jpeg", MimeType.Image);
        public readonly static FileType PNG = new FileType(new byte?[] { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A }, "png", "image/png", MimeType.Image);
        public readonly static FileType GIF = new FileType(new byte?[] { 0x47, 0x49, 0x46, 0x38, null, 0x61 }, "gif", "image/gif", MimeType.Image);

        public readonly static FileType ZIP = new FileType(new byte?[] { 0x50, 0x4B, 0x03, 0x04 }, "zip", "application/x-compressed", MimeType.Archive);
        public readonly static FileType RAR = new FileType(new byte?[] { 0x52, 0x61, 0x72, 0x21 }, "rar", "application/x-compressed", MimeType.Archive);

        // Video
        public readonly static FileType MP4 = new FileType(new byte?[] { 0x66, 0x74, 0x79, 0x70 }, 4, "mp4", "video/mp4", MimeType.Video);
        public readonly static FileType OGV = new FileType(new byte?[] { 0x4F, 0x67, 0x67, 0x53, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, "ogv", "video/ogg", MimeType.Video);
        public readonly static FileType WEBM = new FileType(new byte?[] { 0x1A, 0x45, 0xDF, 0xA3 }, "webm", "video/webm", MimeType.Video);
        public readonly static FileType FLV = new FileType(new byte?[] { 0x46, 0x4c, 0x56, 0x1 }, "flv", "video/x-flv", MimeType.Video);
        
        // all the file types to be put into one list
        private readonly static List<FileType> Types = new List<FileType> { 
            JPEG, PNG, GIF, MP4, OGV, WEBM, FLV};

        // number of bytes we read from a file
        private const int MAX_HEADER_SIZE = 560;  // some file formats have headers offset to 512 bytes
        
        #endregion

        #region Main Methods

        public static FileType GetFileType(string filePath)
        {
            // read first n-bytes from the file
            Byte[] fileHeader = ReadFileHeader(filePath, MAX_HEADER_SIZE);

            // compare the file header to the stored file headers
            foreach (FileType type in Types)
            {
                int matchingCount = 0;
                for (int i = 0; i < type.Header.Length; i++)
                {
                    // if file offset is not set to zero, we need to take this into account when comparing.
                    // if byte in type.header is set to null, means this byte is variable, ignore it
                    if (type.Header[i] != null && type.Header[i] != fileHeader[i + type.HeaderOffset])
                    {
                        // if one of the bytes does not match, move on to the next type
                        matchingCount = 0;
                        break;
                    }
                    else
                    {
                        matchingCount++;
                    }
                }
                if (matchingCount == type.Header.Length)
                {
                    // if all the bytes match, return the type
                    return type;
                }
            }

            
            StringBuilder sb = new StringBuilder();
            foreach (var b in fileHeader)
            {
                sb.AppendFormat("0x{0:x}, ", b);
            }

            Log.Warn("GetFileType: Undefined content type. FileName: '{0}', Signature: '{1}'", Path.GetFileName(filePath), sb);

            // if none of the types match, return null
            return null;
        }

        /// <summary>
        /// Read header of a file and depending on the information in the header
        /// return object FileType.
        /// Return null in case when the file type is not identified. 
        /// Throws Application exception if the file can not be read or does not exist
        /// </summary>
        /// <param name="file">The FileInfo object.</param>
        /// <returns>FileType or null not identified</returns>
        public static FileType GetFileType(this FileInfo file)
        {
            return GetFileType(file.FullName);
        }

        private static byte[] ReadFileHeader(string filename, int maxHeaderSize = 256)
        {
            if (!File.Exists(filename))
                throw new FileNotFoundException(filename + " not found");

            var buffer = new byte[maxHeaderSize];
            using (var fs = new FileStream(filename, FileMode.Open))
            {
                if (fs.Length >= maxHeaderSize)
                    fs.Read(buffer, 0, maxHeaderSize);
                else
                    fs.Read(buffer, 0, (int)fs.Length);
            }

            return buffer;
        }


        /// <summary>
        /// Reads the file header - first (16) bytes from the file
        /// </summary>
        /// <param name="file">The file to work with</param>
        /// <returns>Array of bytes</returns>
        private static Byte[] ReadFileHeader(FileInfo file, int maxHeaderSize)
        {
            Byte[] header = new byte[maxHeaderSize];
            try  // read file
            {
                using (var fsSource = new FileStream(file.FullName, FileMode.Open, FileAccess.Read))
                {
                    // read first symbols from file into array of bytes.
                    fsSource.Read(header, 0, maxHeaderSize);
                }   // close the file stream

            }
            catch (Exception e) // file could not be found/read
            {
                throw new ApplicationException("Could not read file : " + e.Message);
            }

            return header;
        }

        /// <summary>
        /// Determines whether provided file belongs to one of the provided list of files
        /// </summary>
        /// <param name="file">The file.</param>
        /// <param name="requiredTypes">The required types.</param>
        /// <returns>
        ///   <c>true</c> if file of the one of the provided types; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsFileOfTypes(this FileInfo file, List<FileType> requiredTypes)
        {
            FileType currentType = file.GetFileType();

            if (null == currentType )
            {
                return false;
            }

            return requiredTypes.Contains(currentType);
        }

        /// <summary>
        /// Determines whether provided file belongs to one of the provided list of files,
        /// where list of files provided by string with Comma-Separated-Values of extensions
        /// </summary>
        /// <param name="file">The file.</param>
        /// <param name="requiredTypes">The required types.</param>
        /// <returns>
        ///   <c>true</c> if file of the one of the provided types; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsFileOfTypes(this FileInfo file, String CSV)
        {
            List<FileType> providedTypes = GetFileTypesByExtensions(CSV);

            return file.IsFileOfTypes(providedTypes);
        }

        /// <summary>
        /// Gets the list of FileTypes based on list of extensions in Comma-Separated-Values string
        /// </summary>
        /// <param name="CSV">The CSV String with extensions</param>
        /// <returns>List of FileTypes</returns>
        private static List<FileType> GetFileTypesByExtensions(String CSV)
        {
            String[] extensions = CSV.ToUpper().Replace(" ", "").Split(',');

            List<FileType> result = new List<FileType>();

            foreach (FileType type in Types)
            {
                if (extensions.Contains(type.Extension.ToUpper()))
                {
                    result.Add(type);
                }
            }
            return result;
        }

        #endregion

        #region isType functions


        /// <summary>
        /// Determines whether the specified file is of provided type
        /// </summary>
        /// <param name="file">The file.</param>
        /// <param name="type">The FileType</param>
        /// <returns>
        ///   <c>true</c> if the specified file is type; otherwise, <c>false</c>.
        /// </returns>
        public static bool isType(this FileInfo file, FileType type)
        {
            FileType actualType = GetFileType(file);

            if (null == actualType)
                return false;

            return (actualType.Equals(type));
        }

        /// <summary>
        /// Determines whether the specified file is PDF.
        /// </summary>
        /// <param name="file">The file.</param>
        /// <returns>
        ///   <c>true</c> if the specified file is PDF; otherwise, <c>false</c>.
        /// </returns>
        public static bool isPDF(this FileInfo file)
        {
            return file.isType(PDF);
        }


        /// <summary>
        /// Determines whether the specified file info is ms-word document file
        /// </summary>
        /// <param name="fileInfo">The file info.</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is doc; otherwise, <c>false</c>.
        /// </returns>
        public static bool isWord(this FileInfo fileInfo)
        {
            return fileInfo.isType(WORD);
        }


        /// <summary>
        /// Determines whether the specified file is zip archive
        /// </summary>
        /// <param name="fileInfo">The file info.</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is zip; otherwise, <c>false</c>.
        /// </returns>
        public static bool isZip(this FileInfo fileInfo)
        {
            return fileInfo.isType(ZIP);
        }
        
        /// <summary>
        /// Determines whether the specified file is MS Excel spreadsheet
        /// </summary>
        /// <param name="fileInfo">The FileInfo</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is excel; otherwise, <c>false</c>.
        /// </returns>
        public static bool isExcel(this FileInfo fileInfo)
        {
            return fileInfo.isType(EXCEL);
        }

        /// <summary>
        /// Determines whether the specified file is JPEG image
        /// </summary>
        /// <param name="fileInfo">The FileInfo.</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is JPEG; otherwise, <c>false</c>.
        /// </returns>
        public static bool isJpeg(this FileInfo fileInfo)
        {
            return fileInfo.isType(JPEG);
        }

        /// <summary>
        /// Determines whether the specified file is RAR-archive.
        /// </summary>
        /// <param name="fileInfo">The FileInfo.</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is RAR; otherwise, <c>false</c>.
        /// </returns>
        public static bool isRar(this FileInfo fileInfo)
        {
            return fileInfo.isType(RAR);
        }

        /// <summary>
        /// Determines whether the specified file is RTF document.
        /// </summary>
        /// <param name="fileInfo">The FileInfo.</param>
        /// <returns>
        ///   <c>true</c> if the specified file is RTF; otherwise, <c>false</c>.
        /// </returns>
        public static bool isRtf(this FileInfo fileInfo)
        {
            return fileInfo.isType(RTF);
        }

        /// <summary>
        /// Determines whether the specified file is PNG.
        /// </summary>
        /// <param name="fileInfo">The FileInfo object</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is PNG; otherwise, <c>false</c>.
        /// </returns>
        public static bool isPng(this FileInfo fileInfo)
        {
            return fileInfo.isType(PNG);
        }

        /// <summary>
        /// Determines whether the specified file is Microsoft PowerPoint Presentation
        /// </summary>
        /// <param name="fileInfo">The FileInfo object.</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is PPT; otherwise, <c>false</c>.
        /// </returns>
        public static bool isPpt(this FileInfo fileInfo)
        {
            return fileInfo.isType(PPT);
        }

        /// <summary>
        /// Determines whether the specified file is GIF image
        /// </summary>
        /// <param name="fileInfo">The FileInfo object</param>
        /// <returns>
        ///   <c>true</c> if the specified file info is GIF; otherwise, <c>false</c>.
        /// </returns>
        public static bool isGif(this FileInfo fileInfo)
        {
            return fileInfo.isType(GIF);
        }
        
        #endregion
    }




}