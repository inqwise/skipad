package com.skipad.collector.systemFramework;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.HttpRequest;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.restexpress.Request;

import com.inqwise.infrastructure.systemFramework.ApplicationLog;

public class NetworkHelper {
	private static final String HEADER_X_FORWARDED_FOR = "X-Forwarded-For";
	
	static ApplicationLog logger = ApplicationLog.getLogger(NetworkHelper.class);
	
	private static final String internalIPs = 
			"166\\.41\\.8\\.X" + "|" +"12\\.16\\.X\\.X" + "|" +
			"12\\.22\\.X\\.X" + "|" +"132\\.23\\.X\\.X" + "|";

	private static final Pattern p = Pattern.compile("^(?:" + internalIPs.replace("X",
            "(?:\\d{1,2}|1\\d{2}|2[0-4]\\d|25[0-5])")+")$");

	public static String getClientIp(ChannelHandlerContext ctx, HttpRequest request){
		String remoteAddr = null;
		String x;
		if ((x = request.headers().get(HEADER_X_FORWARDED_FOR)) != null) {
			String[] ipList = x.split(",");
			for (String ipAddress : ipList) {
				Matcher m = p.matcher(ipAddress);
				if (!m.matches()) {
					remoteAddr = ipAddress;
					break;
				}
			}
		}
		
		if (null == remoteAddr) {
			remoteAddr = ((InetSocketAddress)ctx.channel().remoteAddress()).getAddress().getHostAddress();
		}
		
		return remoteAddr;    
	}
	
	public static String getLocalHostName() {
		try {
			return java.net.InetAddress.getLocalHost().getHostName();
		} catch (UnknownHostException e) {
			return "u-n-k";
		}
	}

	public static String getClientIp(Request request) {
		String remoteAddr = null;
		String x;
		if ((x = request.getHeader(HEADER_X_FORWARDED_FOR)) != null) {
			String[] ipList = x.split(",");
			for (String ipAddress : ipList) {
				Matcher m = p.matcher(ipAddress);
				if (!m.matches()) {
					remoteAddr = ipAddress;
					break;
				}
			}
		}
		
		if (null == remoteAddr) {
			remoteAddr = request.getRemoteAddress().getAddress().getHostAddress();
		}
		
		return remoteAddr;
	}
}
