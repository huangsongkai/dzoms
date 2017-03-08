package com.dz.common.ocr;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringBufferInputStream;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.w3c.dom.*;
import org.xml.sax.SAXException;

import com.dz.common.other.ObjectAccess;
import com.dz.module.vehicle.electric.ElectricHistory;

public class ElectricTransfer {

	public static void main(String[] args) throws UnsupportedEncodingException {
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		
		List<ElectricFromHtml> list = ObjectAccess.query(ElectricFromHtml.class, " 1=1");
		for (ElectricFromHtml electricFromHtml : list) {
			
			//history.setCarframeNum(electricFromHtml.getCarframeNum());
			if(electricFromHtml.getFetchItems()==0){
				//无违章记录
			}else{
				String context = electricFromHtml.getFetchResult();
				
				String str = StringUtils.split(context, ",")[2];
				
				str = StringUtils.substring(str, 1, str.length()-1);
				str = StringUtils.replace(str, "\\u003c", "<");
				str = StringUtils.replace(str, "\\u003e", ">");
				str = StringUtils.replace(str, "\\\"", "\"");
				
				//str = StringUtils.replace(str, "\\u0027", "\"");
				str = StringUtils.replacePattern(str, "class=\\\\u0027[^\\\\ \\t\\r\\n]+\\\\u0027", "");
				str = StringUtils.replacePattern(str, "height=\\\\u0027[^\\\\ \\t\\r\\n]+\\\\u0027", "");
				str = StringUtils.replacePattern(str, "width=\\\\u0027[^\\\\ \\t\\r\\n]+\\\\u0027", "");
				str = StringUtils.replacePattern(str, "table[^>]+>", "table>");
				str = StringUtils.replacePattern(str, "tr[^>]+>", "tr>");
				str = StringUtils.replacePattern(str, "td[^>]+>", "td>");
				
//				System.out.println(str);
				
				byte[] strBuffer = str.getBytes();
				//for (int i = 0x2400; i <= 0x243F; i++) {
				//	strBuffer = ArrayUtils.removeElement(strBuffer, (byte)i);
				//}
				str = new String(strBuffer);
				str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + str;
				
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(); 
			    DocumentBuilder builder;
				try {
					builder = factory.newDocumentBuilder();
					Document document = builder.parse(new ByteArrayInputStream(str.getBytes()));
					
//					System.out.println(document.toString());
					
					NodeList nl = document.getElementsByTagName("tr");
					
					int nl_len = nl.getLength();
					if(nl_len>1){
						//result = nl.item(0).getTextContent();
						for (int i = 1; i < nl_len; i++) {
							Node tr = nl.item(i);
							NodeList tdlist = tr.getChildNodes();
							
							ElectricHistory history = new ElectricHistory();
							history.setCarframeNum(electricFromHtml.getCarframeNum());
							history.setFecthId(0);
							
							history.setLicenseNum(tdlist.item(0).getTextContent());
							history.setDate(tdlist.item(2).getTextContent());
							history.setMoney(tdlist.item(3).getTextContent());
							
							history.setFen(tdlist.item(4).getTextContent());
							history.setPayState(tdlist.item(5).getTextContent());
							history.setHandled(tdlist.item(6).getTextContent());
							history.setArea(tdlist.item(7).getTextContent());
							history.setAct(tdlist.item(8).getTextContent());
							history.setCode(tdlist.item(9).getTextContent());
							history.setGovernment(tdlist.item(10).getTextContent());
							
							List<ElectricHistory> rh = ObjectAccess.query(ElectricHistory.class, " carframeNum='"+history.getCarframeNum()+"' "
									+ "and date='"+history.getDate()+"' "
									+ "and act='"+history.getAct()+"'");
							if(rh==null||rh.size()==0)
								ObjectAccess.saveOrUpdate(history);
						}
					}
				} catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SAXException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
				
				
//				int beginpos  = StringUtils.indexOf(str, "\\u003ctr class=\\u0027list_body_out\\u0027 onMouseOver=", 0);
//				
//				while(beginpos>0){
//					int nextPos = StringUtils.indexOf(str, "\\u003e\\u003c/tr\\u003e\\u003c",beginpos);
//					if(nextPos>0){
//						String mid = StringUtils.substring(str, beginpos, nextPos);
//						mid = StringUtils.replace(mid, "\\u003ctd\\u003e", "");
//						mid = StringUtils.replace(mid, "\\u003c/td\\u003e", ",");
//						mid = StringUtils.replace(mid, "/td", ",");
//						mid = StringUtils.replace(mid, "\\u003c", "");
//						mid = StringUtils.replace(mid, "\\u003e", "");
//						String[] tds = mid.split(",", 11);
//						
//						if(tds.length<7){
//							break;
//						}
//						
//						ElectricHistory history = new ElectricHistory();
//						try{
//
//							history.setCarframeNum(electricFromHtml.getCarframeNum());
//							history.setFecthId(0);
//							//history.setDate(df.format(electricFromHtml.getFetchTime()));
//							tds[0]=StringUtils.right(tds[0], 7);
//							history.setLicenseNum(tds[0]);
//							history.setDate(tds[2]);
//							history.setMoney(tds[3]);
//							
//							tds[4] = StringUtils.split(tds[4], "\\")[0];
//							history.setFen(tds[4]);
//							history.setArea(tds[7]);
//							history.setAct(tds[8]);
//							
//							System.out.println(history);
//							
//							ObjectAccess.saveOrUpdate(history);
//						}catch(Exception e){
//							e.printStackTrace();
//							System.out.println(Arrays.toString(tds));
//						}
//						
//						
//						beginpos = StringUtils.indexOf(str, "\\u003e\\u003c/tr\\u003e\\u003c",nextPos);
//						if(beginpos<0)
//							break;
//					}else{
//						break;
//					}
//				}
				
			}
		}
	}

}
