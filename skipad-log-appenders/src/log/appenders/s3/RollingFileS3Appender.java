/*
 * MLDX Log Appenders
 * Project hosted at https://github.com/ryanhosp/mldx-log-appenders/
 * Copyright 2012 - 2013 Ho Siaw Ping Ryan
 *    
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 *   
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package log.appenders.s3;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Writer;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import log.appenders.s3.credentials.AbstractCredentialsProvider;

import org.apache.http.impl.cookie.DateUtils;
import org.apache.log4j.RollingFileAppender;
import org.apache.log4j.helpers.CountingQuietWriter;
import org.apache.log4j.helpers.LogLog;
import org.apache.log4j.helpers.OptionConverter;
import org.apache.log4j.spi.LoggingEvent;


public class RollingFileS3Appender extends RollingFileAppender {
	// 3.5 billion. ZIP limit is 4 billion. Some buffer to be safe.
	public static final long FILE_SIZE_LIMIT = 3500000000L;
	// buffer of 10MB
	private static final int BUFFER_SIZE = 10000000;
		
	private AbstractCredentialsProvider credentialsProviderInstance;
	
	private String bucket;
	private String credentialsProvider;
	private Integer expirationInSeconds;
	private ExpirationTimerTask task;
	private String subfolder;
	
	class ExpirationTimerTask extends TimerTask {
		@Override
		public void run() {
			try{
				if(null != expirationDate && null != qw && ((CountingQuietWriter) qw).getCount() > 0 && expirationDate.before(Calendar.getInstance())){
					this.cancel();
			    	try {
						rollOver();
						if(expirationDate.before(Calendar.getInstance())){
							setExpirationDate(null);
						}
					} finally {
						timer.schedule(new ExpirationTimerTask(), 0, 1000);
					}
			    }
			} catch (Throwable t){
				LogLog.error("TimerTask.run(): Failed to execute rollOver", t);
			}
		}
	}
	
	public RollingFileS3Appender() {
		super();
	}
	
	@Override
	public synchronized void setWriter(Writer writer) {
		super.setWriter(writer);
	}
	
	private boolean isInitHandshake;
	
	@Override
	protected void writeHeader() {
		if(isInitHandshake && null != expirationInSeconds){
			setExpirationDate(Calendar.getInstance());
			isInitHandshake = false;
		}
		
		super.writeHeader();
	}
	
	public void setExpirationInSeconds(String expirationInSeconds) {
		this.expirationInSeconds = OptionConverter.toInt(expirationInSeconds, 0);
		timer = new Timer();
		timer.schedule(new ExpirationTimerTask(), 0, 1000);
	}

	private HashMap<String, String> credentialsProviderParams = new HashMap<String, String>();
	private Calendar expirationDate;
	public Calendar getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Calendar expirationDate) {
		System.out.println();
		System.out.print("setExpirationDate:");
		if(null != this.expirationDate){
			System.out.append(" #current: " + this.expirationDate.getTime());
		}
		
		this.expirationDate = expirationDate;
		
		if(null != this.expirationDate){
			System.out.append(" #new: " + this.expirationDate.getTime());
		}
		System.out.println();
	}

	private Timer timer;
		
	public void rollOver(boolean synchronousUpload) {
		final HashSet<File> uploadFileList = new HashSet<File>();
		boolean isPrepareSucceeded = true;
		
		// before rollover, rename all backup files (if any) for copying
		try {
			prepareFilesForUploading(uploadFileList);
			prepareUnprocessedZipFiles(uploadFileList);
		} catch (Throwable t){
			LogLog.error("Failed prepareFilesForUploading", t);
			isPrepareSucceeded = false;
		}
		
		super.rollOver();

		if(isPrepareSucceeded){
			// one file will be rolled over, prepare that for copying as well
			prepareFilesForUploading(uploadFileList);
			
			S3UploadTask uploadTask = new S3UploadTask(uploadFileList, bucket, getCredentialsProviderInstance(), subfolder);
			if(synchronousUpload) {
				uploadTask.run();
			}
			else {
				Thread t = new Thread(uploadTask);
				t.start();
			}
		}
	}
	
	@Override
	public void rollOver() {
		// by default, perform the rollover and S3 upload asynchronously
		rollOver(false);
	}
	
	private AbstractCredentialsProvider getCredentialsProviderInstance(){
		if(credentialsProviderInstance == null) {
			try {
				credentialsProviderInstance = (AbstractCredentialsProvider) Class.forName(credentialsProvider).newInstance();
				credentialsProviderInstance.setParams(credentialsProviderParams);
			}
			catch (InstantiationException e) {
				LogLog.error("Error getting credentials provider " + credentialsProvider, e);
				return null;
			}
			catch (IllegalAccessException e) {
				LogLog.error("Error getting credentials provider " + credentialsProvider, e);
				return null;
			}
			catch (ClassNotFoundException e) {
				LogLog.error("Error getting credentials provider " + credentialsProvider, e);
				return null;
			}
		}
		return credentialsProviderInstance;
	}

	private void prepareUnprocessedZipFiles(final HashSet<File> uploadFileList) {
		
		String fileName = null;
		File folder = new File(getFile());
		if(folder.isFile()){
			fileName = folder.getName();
			folder = folder.getParentFile();
		}
		
		final String finalFileName = fileName;
		
		FileFilter zipFilter = new FileFilter() {
			
			@Override
			public boolean accept(File arg0) {
				return arg0.isFile() && arg0.getName().startsWith(finalFileName) && arg0.getName().toLowerCase().endsWith(".zip") && !uploadFileList.contains(arg0);
			}
		};
		
		File[] zipFiles = folder.listFiles(zipFilter);
		if(null != zipFiles && zipFiles.length > 0){
			LogLog.warn(String.format("prepareUnprocessedZipFiles: Found %s unprocessed zip file(s)", zipFiles.length));
			for (File zipFile : zipFiles) {
				uploadFileList.add(zipFile);
			}
		}
	}
	
	private void prepareFilesForUploading(final HashSet<File> uploadFileList) {
		for(int i = 1; i <= maxBackupIndex; i++) {
			String thisFileName = fileName + "." + i;
			File backupFile = new File(thisFileName);
			
			String fileNameWithoutDir = backupFile.getName();
			if(backupFile.exists()) {
				String copyFileName = thisFileName + "." + UUID.randomUUID().toString() + ".zip";
				
				BufferedInputStream bis = null;
	            ZipOutputStream zos = null;
	            try {
	    			File copyFile = new File(copyFileName);                     
	    			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(copyFile),BUFFER_SIZE);
	    			zos = new ZipOutputStream(bos);
	    			zos.setLevel(9);
	    			
	    			ZipEntry zipEntry = new ZipEntry(fileNameWithoutDir);
	    			zos.putNextEntry(zipEntry);
	    			
	    			FileInputStream fis = new FileInputStream(backupFile);
	                bis = new BufferedInputStream(fis,BUFFER_SIZE);
	                
	                byte[] buf = new byte[BUFFER_SIZE];
	                int bytesRead = 0;
	                while((bytesRead = bis.read(buf)) != -1) {
	                	if(bytesRead < BUFFER_SIZE) {
	                		byte[] buf2 = new byte[bytesRead];
	                		System.arraycopy(buf, 0, buf2, 0, bytesRead);
	                		buf = buf2;
	                	}
	                	zos.write(buf);
	                	buf = new byte[BUFFER_SIZE];
	                }
	                zos.closeEntry();
	                bis.close();
					backupFile.delete();
					uploadFileList.add(copyFile);	
	            }
	            catch(IOException e) {
	            	throw new RuntimeException(e);
	            }
	            finally{
					try {
						if (bis != null) {
							bis.close();
						}
						if (zos != null) {
							zos.close();
						}
					} catch (IOException e) {
						// nothing needs to be done here
					}	
	            }
			}
		}
	}
	
	@Override
	public void setMaxFileSize(String value) {
		super.setMaxFileSize(value);
		// the parent setter converts the String value to a long value, so let the parent run first
		checkMaxFileSize();
	}

	private void checkMaxFileSize() {
		if(maxFileSize > FILE_SIZE_LIMIT) {
			throw new IllegalArgumentException("Exceeded file size limit " + FILE_SIZE_LIMIT);
		}
	}

	@Override
	public void setMaximumFileSize(long maxFileSize) {
		checkMaxFileSize();
		super.setMaximumFileSize(maxFileSize);
	}

	@Override
	public void setMaxBackupIndex(int maxBackups) {
		if(maxBackupIndex <1){
			throw new IllegalArgumentException("maxBackupIndex needs to be 1 or more.");
		}
		super.setMaxBackupIndex(maxBackups);
	}

	public String getBucket() {
		return bucket;
	}

	public void setBucket(String bucket) {
		this.bucket = bucket;
	}
	
	public String getCredentialsProvider() {
		return credentialsProvider;
	}

	
	
	public void setCredentialsProvider(String credentialsProvider) {
		this.credentialsProvider = credentialsProvider;
	}

	/* ------------------------------------------------
	 *  for env var encrypted file credentials provider
	 */
	
	public String getAccessKeyEnvVarName() {
		return credentialsProviderParams.get("accessKeyEnvVarName");
	}

	public void setAccessKeyEnvVarName(String accessKeyEnvVarName) {
		credentialsProviderParams.put("accessKeyEnvVarName",accessKeyEnvVarName);
	}

	public String getSecretKeyEnvVarName() {
		return credentialsProviderParams.get("secretKeyEnvVarName");
	}

	public void setSecretKeyEnvVarName(String secretKeyEnvVarName) {
		credentialsProviderParams.put("secretKeyEnvVarName",secretKeyEnvVarName);
	}
	
	public void setAccessKey(String accessKey) {
		credentialsProviderParams.put("AccessKey",accessKey);
	}

	public void setSecretKey(String secretKey) {
		credentialsProviderParams.put("SecretKey", secretKey);
	}

	/* for env var credentials provider
	 * ------------------------------------------------
	 */

	
	
	/* ------------------------------------------------
	 *  for jets3t encrypted file credentials provider
	 */
	
	public String getCredentialsFilePath() {
		return credentialsProviderParams.get("credentialsFilePath");
	}

	public void setCredentialsFilePath(String credentialsFilePath) {
		credentialsProviderParams.put("credentialsFilePath",credentialsFilePath);
	}

	public String getCredentialsFilePassword() {
		return credentialsProviderParams.get("credentialsFilePassword");
	}

	public void setCredentialsFilePassword(String credentialsFilePassword) {
		credentialsProviderParams.put("credentialsFilePassword",credentialsFilePassword);
	}

	/* for jets3t encrypted file credentials provider
	 * ------------------------------------------------
	 */
	
	@Override
	public void append(LoggingEvent event) {
		if(null != expirationInSeconds && null == expirationDate){
			Calendar date = Calendar.getInstance();
			date.add(Calendar.SECOND, expirationInSeconds);
			setExpirationDate(date);
		}
		super.append(event);
	}

	public String getSubfolder() {
		return subfolder;
	}

	public void setSubfolder(String subfolder) {
		this.subfolder = subfolder;
	};
	
	/*
	@Override
	protected void subAppend(LoggingEvent event) {
	    if(null != expirationDate && expirationDate.before(Calendar.getInstance())){
	    	rollOver();
	    } else {
	    	super.subAppend(event);
	    }
   }
   */
}
