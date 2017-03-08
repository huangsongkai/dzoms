package com.dz.common.other;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionContext;

@Component
public class Timer {
	@Scheduled(cron="0 0 0 * * ?")
	public void cleanTempFiles(){
		Map<String, Object> appliaction = ActionContext.getContext().getApplication();
		Map<String,String> map = (Map<String,String>)appliaction.get("TempFileMap");
		
		System.out.println("Clean the temp file......");
		
		File file = new File(System.getProperty("com.dz.root")+"tmp");
		
		for(File tmpFile:file.listFiles()){
			String filename = file.getName();
			map.remove(filename);
			file.delete();
		}
	}
	
	private static ServerSocket server;
	
	/**
	 * 用于启动Tcp 文件上传组件
	 */
	@Scheduled(cron="0 0/10 * * * ?")
	public void startTcpServer(){
		if(server==null)
		try {
			System.out.println("TCP服务开启。。。。。。");
			server = new ServerSocket(32767);
			new Thread(new Runnable() {
				@Override
				public void run() {
					while(true)
					try {
						Socket s=server.accept();
						while(true){
							if(s!=null){
								System.out.println(s+"连接");    //在控制台打印客户连接信息
								break;
							}
						}
						BufferedInputStream bis = new BufferedInputStream(s.getInputStream());
						byte[] seqbuff = new byte[60];
						bis.read(seqbuff);
						String seq = new String(seqbuff,"UTF-16LE");
						System.out.println("seq:"+seq);
						
						String path = FileTcpUpload.seqMap.get(seq);
						File file = new File(System.getProperty("com.dz.root")+path);
						if(!file.getParentFile().exists())
							file.getParentFile().mkdirs();
						if(!file.exists())
							file.createNewFile();
						
						BufferedOutputStream os = new BufferedOutputStream(FileUtils.openOutputStream(file));
						
						byte[] filebuff = new byte[4096];
						int i;
						while((i=bis.read(filebuff))>0){
							os.write(filebuff, 0, i);
						}
						
						os.flush();
						os.close();
						
						bis.close();
						
						FileTcpUpload.seqMap.remove(seq);
						
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}).start();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
}
