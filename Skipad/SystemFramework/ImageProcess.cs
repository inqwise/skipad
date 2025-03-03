using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;

namespace Inqwise.Skipad.SystemFramework
{
    

    /// <summary>
    /// Summary description for ImageProcess
    /// </summary>
    public class ImageProcess
    {
        public struct ImageProcessResult
        {
            public string Path;
            public string FileName;
            public string Extension;
            public Image Image;
            public string ContentType;
            public int Height;
            public int Width;
        }

        public const string FILENAME_FORMAT = "{0}_{1}x{2}x{3:x2}.{4}"; //{namePrefix}_{width}x{height}x{timestamp}.{extension}
        public const string JPEG_EXTENSION_NAME = "jpg";
        private const int DEFAULT_JPEG_QUALITY = 90;
        public const string JPEG_CONTENT_TYPE = "image/jpeg";

        public Image Image { get; private set; }
        public string NamePrefix { get; private set; }

        public ImageProcess(string path, string namePrefix)
        {
            Image = new Bitmap(path);
            NamePrefix = namePrefix;
        }

        public void Crop()
        {
            if (Image.Width / (double)Image.Height > (16.0 / 9.0 + 0.02))
            {
                int startX = Convert.ToInt32((Image.Width - Image.Height * 16.0 / 9.0) / 2.0);
                int width = Convert.ToInt32(Image.Height * 16.0 / 9.0);
                Image = CropImage(Image, Image.Height, width, startX, 0);
            }
            else if (Image.Width / (double)Image.Height < (16.0 / 9.0 - 0.02))
            {
                int startY = Convert.ToInt32((Image.Height - Image.Width * 9.0 / 16.0) / 2.0);
                int height = Convert.ToInt32(Image.Width * 9.0 / 16.0);
                Image = CropImage(Image, height, Image.Width, 0, startY);
            }
        }

        public ImageProcessResult ConvertAndSaveAsJpeg(Tuple<int, int, int> size, string outputFolder)
        {
            var result = new ImageProcessResult
                {
                    FileName = string.Format(FILENAME_FORMAT, NamePrefix, size.Item1, size.Item2, DateTime.Now.Ticks, JPEG_EXTENSION_NAME),
                    Extension = JPEG_EXTENSION_NAME,
                    ContentType = JPEG_CONTENT_TYPE,
                    Height = size.Item2,
                    Width = size.Item1,
                };

            result.Path = Path.Combine(outputFolder, result.FileName);

            //result.Image = ScaleImage(Image, size.Item1, size.Item2);
            result.Image = HardResizeImage(size.Item1, size.Item2, Image);
            //result.Image = CropImage(result.Image, size.Item2, size.Item1);

            SaveJpeg(result.Path, result.Image, DEFAULT_JPEG_QUALITY);

            return result;
        }

        private void SaveJpeg(string path, Image image, long quality)
        {
            //ensure the quality is within the correct range
            if ((quality < 0) || (quality > 100))
            {
                //create the error message
                string error = string.Format("Jpeg image quality must be between 0 and 100, with 100 being the highest quality.  A value of {0} was specified.", quality);
                //throw a helpful exception
                throw new ArgumentOutOfRangeException(error);
            }

            //create an encoder parameter for the image quality
            EncoderParameter qualityParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);
            //get the jpeg codec
            ImageCodecInfo jpegCodec = GetEncoderInfo("image/jpeg");

            //create a collection of all parameters that we will pass to the encoder
            EncoderParameters encoderParams = new EncoderParameters(1);
            //set the quality parameter for the codec
            encoderParams.Param[0] = qualityParam;
            //save the image using the codec and the parameters
            image.Save(path, jpegCodec, encoderParams);
        }


        private Image ScaleImage(Image image, int maxWidth, int maxHeight)
        {
            var ratioX = (double)maxWidth / image.Width;
            var ratioY = (double)maxHeight / image.Height;
            var ratio = Math.Min(ratioX, ratioY);

            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            var newImage = new Bitmap(newWidth, newHeight);
            Graphics.FromImage(newImage).DrawImage(image, 0, 0, newWidth, newHeight);
            return newImage;
        }

        //Overload for crop that default starts top left of the image.
        private Image CropImage(Image Image, int Width, int Height)
        {
            return CropImage(Image, Height, Width, 0, 0);
        }

        //The crop image sub
        private Image CropImage(Image Image, int Height, int Width, int StartAtX, int StartAtY)
        {
            Image outimage;
            MemoryStream mm = null;
            try
            {
                //check the image height against our desired image height
                if (Image.Height < Height)
                {
                    Height = Image.Height;
                }

                if (Image.Width < Width)
                {
                    Width = Image.Width;
                }

                //create a bitmap window for cropping
                Bitmap bmPhoto = new Bitmap(Width, Height, PixelFormat.Format24bppRgb);
                bmPhoto.SetResolution(72, 72);

                //create a new graphics object from our image and set properties
                Graphics grPhoto = Graphics.FromImage(bmPhoto);
                grPhoto.SmoothingMode = SmoothingMode.AntiAlias;
                grPhoto.InterpolationMode = InterpolationMode.HighQualityBicubic;
                grPhoto.PixelOffsetMode = PixelOffsetMode.HighQuality;

                //now do the crop
                grPhoto.DrawImage(Image, new Rectangle(0, 0, Width, Height), StartAtX, StartAtY, Width, Height, GraphicsUnit.Pixel);

                // Save out to memory and get an image from it to send back out the method.
                mm = new MemoryStream();
                bmPhoto.Save(mm, System.Drawing.Imaging.ImageFormat.Jpeg);
                Image.Dispose();
                bmPhoto.Dispose();
                grPhoto.Dispose();
                outimage = Image.FromStream(mm);

                return outimage;
            }
            catch (Exception ex)
            {
                throw new Exception("Error cropping image, the error was: " + ex.Message);
            }
        }

        //Hard resize attempts to resize as close as it can to the desired size and then crops the excess
        private Image HardResizeImage(int maxWidth, int maxHeight, Image image)
        {
            var imageScale = (decimal) image.Width/(decimal) image.Height;
            var newScale = (decimal)maxWidth / (decimal)maxHeight;

            Image cropedImage = null;
            if (decimal.Round(imageScale, 2) != decimal.Round(newScale, 2))
            {
                int cropWidth;
                int cropHeight;

                if (imageScale > newScale)
                {
                    cropWidth = Convert.ToInt32(image.Height*newScale);
                    cropHeight = image.Height;
                }
                else
                {
                    cropWidth = image.Width;
                    cropHeight = Convert.ToInt32(image.Width/newScale);
                }
                
                cropedImage = CropImage(image, cropWidth, cropHeight);
            }
            
            var output = ResizeImage(maxWidth, maxHeight, cropedImage ?? image);
            if (null != cropedImage && (output.Width > maxWidth || output.Height > maxHeight))
            {
                output = CropImage(output, maxWidth, maxHeight);
            }

            //return the original resized image
            return output;
        }

        //Image resizing
        private Image ResizeImage(int maxWidth, int maxHeight, Image image)
        {
            int width = image.Width;
            int height = image.Height;
            //if (width > maxWidth || height > maxHeight)
            {
                //The flips are in here to prevent any embedded image thumbnails -- usually from cameras
                //from displaying as the thumbnail image later, in other words, we want a clean
                //resize, not a grainy one.
                image.RotateFlip(RotateFlipType.Rotate180FlipX);
                image.RotateFlip(RotateFlipType.Rotate180FlipX);

                float ratio = 0;
                if (width > height)
                {
                    ratio = (float)width / (float)height;
                    width = maxWidth;
                    height = Convert.ToInt32(Math.Round((float)width / ratio));
                }
                else
                {
                    ratio = (float)height / (float)width;
                    height = maxHeight;
                    width = Convert.ToInt32(Math.Round((float)height / ratio));
                }

                //return the resized image
                return image.GetThumbnailImage(width, height, null, IntPtr.Zero);
            }
            //return the original resized image
            return image;
        }

        /// <summary>
        /// A quick lookup for getting image encoders
        /// </summary>
        private Dictionary<string, ImageCodecInfo> encoders = null;

        /// <summary>
        /// A quick lookup for getting image encoders
        /// </summary>
        private Dictionary<string, ImageCodecInfo> Encoders
        {
            //get accessor that creates the dictionary on demand
            get
            {
                //if the quick lookup isn't initialised, initialise it
                if (encoders == null)
                {
                    encoders = new Dictionary<string, ImageCodecInfo>();
                }

                //if there are no codecs, try loading them
                if (encoders.Count == 0)
                {
                    //get all the codecs
                    foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageEncoders())
                    {
                        //add each codec to the quick lookup
                        encoders.Add(codec.MimeType.ToLower(), codec);
                    }
                }

                //return the lookup
                return encoders;
            }
        }

        /// <summary> 
        /// Returns the image codec with the given mime type 
        /// </summary> 
        private ImageCodecInfo GetEncoderInfo(string mimeType)
        {
            //do a case insensitive search for the mime type
            string lookupKey = mimeType.ToLower();

            //the codec to return, default to null
            ImageCodecInfo foundCodec = null;

            //if we have the encoder, get it to return
            if (Encoders.ContainsKey(lookupKey))
            {
                //pull the codec from the lookup
                foundCodec = Encoders[lookupKey];
            }

            return foundCodec;
        }
    }
}