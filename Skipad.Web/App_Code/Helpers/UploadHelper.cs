using System;
using System.IO;
using System.Web;
using Inqwise.Skipad.Common;
using Inqwise.Skipad.Common.Errors;

namespace Helpers
{
    public class UploadHelper
    {
        public string FileNamePrefix { get; private set; }
        public string UploadDir { get; set; }
        public int MaxFileSize { get; set; }
        public int MinFileSize { get; set; }
        public bool DiscardAbortedUploads { get; set; }

        public UploadHelper()
        {
            PropertiesInit(null);
        }

        public UploadHelper(string uploadDir)
        {
            PropertiesInit(uploadDir);
        }

        private void PropertiesInit(string uploadDir)
        {
            this.FileNamePrefix = string.Format("{0:x2}", DateTime.Now.Ticks);
            this.UploadDir = uploadDir;
            // Set the following option to 'POST', if your server does not support
            // DELETE requests. This is a parameter sent to the client:
            // The web.config setting maxRequestLength
            // takes precedence over max_file_size:
            //<system.web>
            //<httpRuntime executionTimeout="240" maxRequestLength="10124" />
            //</system.web>
            this.MaxFileSize = 10124000;
            this.MinFileSize = 1;
            //this.AcceptFileTypes = @"^.+\.((jpg)|(gif)|(jpeg)|(png))$";
            this.DiscardAbortedUploads = true;
            //Set to true to rotate images based on EXIF meta data, if available:
            //this.orient_images = false;
            // Uncomment the following version to restrict the size of
            // uploaded images. You can also add additional versions with
            // their own upload directories:
            /*this.image_versions = new Dictionary<string, ResourceFileInfo>() {
                {"Large",new ResourceFileInfo(){width=250,height=250, dir=this.upload_dir + "Large/", url=this.upload_url + "Large/"}}
                ,{"Thumbnail",new ResourceFileInfo(){width=80,height=80, dir=this.upload_dir + "Thumbnail/", url = this.upload_url + "Thumbnail/"}}
            };*/
        }

        /*
        public ResourceFileInfo FileObjectGet(string fileName)
        {
            var file = new ResourceFileInfo();
            string filePath = this.UploadDir + fileName;
            if (FileInfo.Exists(filePath) && fileName.Length > 0 && fileName.Substring(0, 1) != ".")
            {
                file.Name = fileName;
                file.Size = new FileInfo(filePath).Length;
                file.url = this.upload_url + HttpUtility.UrlEncode(fileName);
            }
            return file;
        }

        public List<ResourceFileInfo> FileObjectsGet()
        {
            List<ResourceFileInfo> infoList = new List<ResourceFileInfo>();
            foreach (string file in Directory.GetFiles(this.UploadDir))
            {
                infoList.Add(FileObjectGet(Path.GetFileName(file)));
            }
            return infoList;
        }

        public bool ScaledImageCreate(ResourceFileInfo file)
        {
            string file_path = this.UploadDir + file.Name;
            string new_file_path = file.dir + file.Name;
            Image img = Image.FromFile(file_path);
            string fileNameExtension = Path.GetExtension(file_path).ToLower();
            ImageFormat imageType = GetImageType(fileNameExtension);
            if (img == null)
            {
                return false;
            }
            int img_width = img.Width;
            int img_height = img.Height;

            if (img_width < 1 || img_height < 1)
            {
                return false;
            }

            float scale = Math.Min(file.width/(float) img_width, file.height/(float) img_height);

            int new_width = (int) Math.Round(img_width*scale, 0);
            int new_height = (int) Math.Round(img_height*scale, 0);

            Bitmap new_image = new Bitmap(new_width, new_height);
            Graphics g = Graphics.FromImage(new_image);
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            g.PixelOffsetMode = PixelOffsetMode.HighQuality;

            foreach (PropertyItem pItem in img.PropertyItems)
            {
                new_image.SetPropertyItem(pItem);
            }

            g.DrawImage(img, new Rectangle(0, 0, new_width, new_height));

            img.Dispose();

            new_image.Save(new_file_path, imageType);
            new_image.Dispose();

            return true;
        }

        private static ImageFormat GetImageType(string fileExt)
        {
            switch (fileExt)
            {
                case ".jpg":
                    return ImageFormat.Jpeg;
                case ".gif":
                    return ImageFormat.Gif;
                default: // (png)
                    return ImageFormat.Png;
            }
        }*/

        public bool Validate(HttpPostedFile uploadedFile, ResourceFileInfo file)
        {
            if (file.HasError)
            {
                return false;
            }

            if (String.IsNullOrEmpty(file.Name))
            {
                file.Error = SkipadErrors.MissingFileName;
                return false;
            }
            if (file.Name.IndexOfAny(Path.GetInvalidFileNameChars()) != -1)
            {
                file.Error = SkipadErrors.InvalidFileName;
                return false;
            }

            /*if (!Regex.IsMatch(file.Name, this.AcceptFileTypes, RegexOptions.Multiline | RegexOptions.IgnoreCase))
            {
                file.Error = "acceptFileTypes";
                return false;
            }*/

            if (this.MaxFileSize > 0 && (file.Size > this.MaxFileSize))
            {
                file.Error = SkipadErrors.MaxFileSize;
                return false;
            }
                
            if (this.MinFileSize > 1 && (file.Size < this.MinFileSize))
            {
                file.Error = SkipadErrors.MinFileSize;
                return false;
            }
                
            return true;
        }

        public ResourceFileInfo FileUploadHandle(HttpPostedFile uploadedFile, ResourceFileInfo file)
        {
            if (Validate(uploadedFile, file))
            {
                long actualFileSize = uploadedFile.InputStream.Length;
                file.FilePath = this.UploadDir + FileNamePrefix + file.Name;
                bool appendFile = !this.DiscardAbortedUploads && File.Exists(file.FilePath)
                                    || file.Size > actualFileSize;

                    
                // multipart/formdata uploads (POST method uploads)
                if (appendFile)
                {
                    using (FileStream fs = File.Open(file.FilePath, FileMode.Append))
                    {
                        uploadedFile.InputStream.CopyTo(fs);
                        fs.Flush();
                    }
                }
                else
                {
                    using (FileStream fs = File.OpenWrite(file.FilePath))
                    {
                        uploadedFile.InputStream.CopyTo(fs);
                        fs.Flush();
                    }
                }

                /*
                if (file.Size == new FileInfo(filePath).Length)
                {
                    //Validate again for chunked files.
                    if (Validate(uploadedFile, file, error, index))
                    {
                        //if (this.orient_images)
                        //{
                        //    //orient_image(file_path);
                        //}
                        //Create different versions
                        file.url = this.upload_url + HttpUtility.UrlEncode(file.Name);
                    }
                }
                else
                {
                    if (!appendFile && this.DiscardAbortedUploads)
                    {
                        FileInfo.Delete(filePath);
                        file.Error = "abort";
                    }

                }*/

                if (file.Size > actualFileSize && !appendFile && this.DiscardAbortedUploads)
                {
                    File.Delete(file.FilePath);
                    file.Error = SkipadErrors.Abort;
                }
            }

            return file;
        }
    }

    /*
    public static class Json
    {
        public static T Deserialise<T>(string json)
        {
            T obj = Activator.CreateInstance<T>();
            using (MemoryStream ms = new MemoryStream(Encoding.Unicode.GetBytes(json)))
            {
                DataContractJsonSerializer serializer = new DataContractJsonSerializer(obj.GetType());
                obj = (T) serializer.ReadObject(ms);
                return obj;
            }
        }

        public static string Serialize<T>(T obj)
        {
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(obj.GetType());
            using (MemoryStream ms = new MemoryStream())
            {
                serializer.WriteObject(ms, obj);
                return Encoding.Default.GetString(ms.ToArray());
            }
        }
    }
     */
}