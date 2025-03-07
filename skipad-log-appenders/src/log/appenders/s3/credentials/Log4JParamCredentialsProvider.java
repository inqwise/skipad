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
package log.appenders.s3.credentials;

import org.jets3t.service.security.AWSCredentials;
import org.jets3t.service.security.ProviderCredentials;

public class Log4JParamCredentialsProvider extends AbstractCredentialsProvider {

	@Override
	public ProviderCredentials getAWSCredentials() {
		String accessKey = params.get("AccessKey");
		String secretKey = params.get("SecretKey");
		ProviderCredentials awsCredentials = new AWSCredentials(accessKey, secretKey);
		return awsCredentials;
	}
}
