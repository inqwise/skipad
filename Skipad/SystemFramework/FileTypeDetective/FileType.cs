namespace Inqwise.Skipad.SystemFramework.FileTypeDetective
{

    public enum MimeType
    {
        Undefined,
        Video,
        Image,
        Document,
        Archive,
        Audio
    }

    /// <summary>
    /// Little data structure to hold information about file types. 
    /// Holds information about binary header at the start of the file
    /// </summary>
    public class FileType
    {
        public byte?[] Header { get; private set; }    // most of the times we only need first 8 bytes, but sometimes extend for 16
        public int HeaderOffset { get; private set; }
        public string Extension { get; private set; }
        public string Mime { get; private set; }
        public MimeType MimeType { get; private set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="FileType"/> class.
        /// Default construction with the header offset being set to zero by default
        /// </summary>
        /// <param name="header">Byte array with header.</param>
        /// <param name="extension">String with extension.</param>
        /// <param name="mime">The description of MIME.</param>
        public FileType(byte?[] header, string extension, string mime, MimeType mimeType)
        {
            this.Header = header;
            this.Extension = extension;
            this.Mime = mime;
            this.HeaderOffset = 0;
            this.MimeType = mimeType;
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="FileType"/> struct.
        /// Takes the details of offset for the header
        /// </summary>
        /// <param name="header">Byte array with header.</param>
        /// <param name="offset">The header offset - how far into the file we need to read the header</param>
        /// <param name="extension">String with extension.</param>
        /// <param name="mime">The description of MIME.</param>
        public FileType(byte?[] header, int offset, string extension, string mime, MimeType mimeType)
        {
            this.Header = null;
            this.Header = header;
            this.HeaderOffset = offset;
            this.Extension = extension;
            this.Mime = mime;
            this.MimeType = mimeType;
        }


        public override bool Equals(object other)
        {
            if (!base.Equals(other)) return false;

            if (!(other is FileType)) return false;

            var otherType = (FileType)other;

            if (this.Header != otherType.Header) return false;
            if (this.HeaderOffset != otherType.HeaderOffset) return false;
            if (this.Extension != otherType.Extension) return false;
            if (this.Mime != otherType.Mime) return false;


            return true;
        }

        public override string ToString()
        {
            return Extension;
        }
    }
}
